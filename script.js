document.addEventListener('alpine:init', () => {
    Alpine.data('app', () => ({
        activeTab: 'home', sidebarOpen: false, activeModal: '', modalMessage: '', notification: { show: false, message: '' }, confirmResolver: null,
        init() { this.$nextTick(() => this.updateNavIndicator()); },
        setActiveTab(tab, event) {
            const oldTab = this.activeTab; this.activeTab = tab; this.updateNavIndicator(event.currentTarget);
            if (oldTab === 'tweaks' && tab !== 'tweaks') stopDiagnosis();
            if (tab === 'tweaks' && oldTab !== 'tweaks') { setTimeout(() => startDiagnosis(), 500); }
        },
        updateNavIndicator(target) {
            const indicator = document.getElementById('nav-indicator');
            if (!target) target = this.$refs.nav.querySelector('.nav-item.active');
            if (target) {
                indicator.style.width = `${target.offsetWidth}px`;
                indicator.style.transform = `translateX(${target.offsetLeft}px)`;
                document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
                target.classList.add('active');
            }
        },
        showConfirm(message) { this.modalMessage = message; this.activeModal = 'confirm'; return new Promise(resolve => { this.confirmResolver = resolve; }); },
        resolveConfirm(value) { this.confirmResolver?.(value); this.activeModal = ''; },
        showNotification(message, duration = 3000) { this.notification.message = message; this.notification.show = true; setTimeout(() => { this.notification.show = false; }, duration); },
        async disableDns() { this.modalMessage = 'Disabling Adblock DNS...'; this.activeModal = 'processing'; try { await executeShellCommand(COMMANDS.disable_dns, 'SilentOp', `dns-disable-${generateRandomId()}`); this.activeModal = ''; this.showNotification('Adblock DNS has been disabled successfully.'); } catch (e) { console.error("Failed to disable DNS:", e); this.activeModal = 'dnsWarning'; this.showNotification('Failed to disable DNS. Please try again.'); } }
    }));
});

let realtimeUpdateInterval = null, diagnosisInterval = null, diagnosisChart = null;
const cpuState = { prevIdle: 0, prevTotal: 0 };
const VERSION_URL = "version.json", COMMANDS_URL = "commands.json", RESTORE_URL = "restore.json";
let COMMANDS = {}, RESTORE_COMMANDS = {}, tweakSettings = {};
let allModules = [], allFpsModules = [], allFakeDevices = [], allGames = [];
let lastFoundGames = []; 

let PERFORMANCE_COMMANDS = {};
const GAME_JSON_URL = "game.json"; 
const PERFORMANCE_JSON_URL = "performance.json";
const selectedGames = new Set(JSON.parse(localStorage.getItem("selectedGames") || "[]"));
let boostState = {}; // NEW: Global state for before/after stats

function getAlpine() { return document.body._x_dataStack[0]; }
function generateRandomId() { return Array.from({ length: 15 }, () => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01223456789'.charAt(Math.floor(Math.random() * 62))).join(''); }
function parseAnsiColors(text) { const ansiMap = {'\x1B[0;31m': '<span class="ansi-red">', '\x1B[0;32m': '<span class="ansi-green">', '\x1B[0;36m': '<span class="ansi-cyan">', '\x1B[1;33m': '<span class="ansi-yellow">', '\x1B[0m': '</span>'}; let html = text.replace(/[&<>"']/g, m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[m]); return Object.entries(ansiMap).reduce((acc, [ansi, tag]) => acc.replace(new RegExp(ansi.replace(/\[/g, '\\['), 'g'), tag), html); }

const MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/refs/heads/main/Modules.json", FPS_MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/refs/heads/main/FpsSetting.json", FAKE_DEVICE_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/main/FakeDevice.json";
const downloadedModules = new Set(JSON.parse(localStorage.getItem("downloadedModules") || "[]")), activeModules = new Set(JSON.parse(localStorage.getItem("activeModules") || "[]")), activeFakeDevices = new Set(JSON.parse(localStorage.getItem("activeFakeDevices") || "[]"));
let commandLogs = JSON.parse(localStorage.getItem("commandLogs") || "[]");

async function loadAppVersion() { try { const version = window.Android?.getAppVersion ? await window.Android.getAppVersion() : "0.0.0"; document.getElementById("app-version").textContent = `Version: ${version || 'Unknown'}`; return version; } catch (e) { console.error("Error loading app version:", e); document.getElementById("app-version").textContent = "Version: Error"; return "0.0.0"; } }
async function checkShizukuStatus() { try { const status = window.Android?.getShizukuStatus ? await window.Android.getShizukuStatus() : false; document.getElementById("shizuku-status").innerHTML = `<i class="fas ${status ? 'fa-check-circle' : 'fa-times-circle'}" style="color: ${status ? '#10b981' : '#ef4444'};"></i><span>Shizuku: ${status ? 'Running' : 'Not Running'}</span>`; return status; } catch (e) { console.error("Error checking Shizuku status:", e); document.getElementById("shizuku-status").innerHTML = `<i class="fas fa-exclamation-circle" style="color: #f59e0b;"></i><span>Shizuku: Error</span>`; return false; } }
function compareVersions(v1, v2) { const p1 = v1.split('.').map(Number), p2 = v2.split('.').map(Number); for (let i = 0; i < Math.max(p1.length, p2.length); i++) { const n1 = p1[i] || 0, n2 = p2[i] || 0; if (n1 > n2) return 1; if (n1 < n2) return -1; } return 0; }
async function checkForUpdates() { try { const localVersion = await loadAppVersion(); if (localVersion === "0.0.0") return; const response = await fetch(VERSION_URL, { cache: "no-store" }); const data = await response.json(); if (compareVersions(data.latestVersion, localVersion) > 0) { document.getElementById('update-version').textContent = data.latestVersion; document.getElementById('update-notes').innerHTML = `<ul>${data.releaseNotes.map(note => `<li>${note}</li>`).join('')}</ul>`; document.getElementById('update-link').href = data.downloadUrl; getAlpine().activeModal = 'update'; } } catch (e) { console.error("Update check failed:", e); } }
function executeShellCommand(command, moduleName, id) {
    return new Promise((resolve, reject) => {
        if (!window.Android?.executeCommand) { return reject(new Error("Android interface not available.")); }
        let output = "";
        const originalOnShellOutput = window.onShellOutput;
        const originalRunComplete = window.runComplete;
        const timeoutId = setTimeout(() => {
            cleanup();
            reject(new Error(`Command timed out: ${moduleName}`));
        }, 30000); // 30-second timeout for long scripts
        const cleanup = () => {
            clearTimeout(timeoutId);
            window.onShellOutput = originalOnShellOutput;
            window.runComplete = originalRunComplete;
        };
        window.onShellOutput = (mName, data, logId) => { if (logId === id) { output += data + "\n"; } else if (originalOnShellOutput) { originalOnShellOutput(mName, data, logId); } };
        window.runComplete = (mName, success, logId) => { if (logId === id) { cleanup(); if (success) { resolve(output.trim()); } else { reject(new Error(`Command failed: ${moduleName}`)); } } else if (originalRunComplete) { originalRunComplete(mName, success, logId); } };
        try { window.Android.executeCommand(command, moduleName, id); } catch (e) { cleanup(); reject(e); }
    });
}
async function checkDnsStatus() { try { const command = `mode=$(settings get global private_dns_mode); spec=$(settings get global private_dns_specifier); if [[ "$mode" == "hostname" && ("$spec" == *adguard* || "$spec" == *nextdns*) ]]; then echo "ADBLOCK_DNS_DETECTED"; else echo "OK"; fi`; const output = await executeShellCommand(command, 'DnsCheck', `dns-check-${generateRandomId()}`); if (output.trim() === "ADBLOCK_DNS_DETECTED") getAlpine().activeModal = 'dnsWarning'; } catch (e) { console.error("DNS check failed:", e); } }
async function initializeDashboard() { if (!(await checkShizukuStatus())) { document.getElementById('dashboard-loading').innerHTML = `<p class="text-yellow-400 text-sm"><i class="fas fa-exclamation-triangle mr-2"></i>Shizuku not running. Cannot fetch live data.</p>`; return; } const command = [ "getprop ro.product.brand", "getprop ro.product.model", "getprop ro.product.cpu.abi", "getprop ro.build.version.sdk", "getprop ro.build.id", "[ $(su -c 'echo 1' 2>/dev/null) ] && echo 'Yes' || echo 'No'", "uptime -p" ].join(" && echo '---NEON_SPLIT---' && "); try { const output = await executeShellCommand(command, 'DeviceInfo', `static-${generateRandomId()}`); const parts = output.split('---NEON_SPLIT---\n'); document.getElementById('device-name').textContent = `${parts[0] ?? '...'} ${parts[1] ?? '...'}`; document.getElementById('device-cpu-arch').textContent = parts[2] ?? '...'; document.getElementById('device-sdk').textContent = parts[3] ?? '...'; document.getElementById('device-build').textContent = parts[4] ?? '...'; document.getElementById('device-root').textContent = parts[5] ?? '...'; document.getElementById('device-uptime').textContent = (parts[6] ?? '...').replace('up ',''); document.getElementById('dashboard-loading').style.display = 'none'; document.getElementById('dashboard-grid').style.display = 'grid'; await updateRealtimeInfo(); if (realtimeUpdateInterval) clearInterval(realtimeUpdateInterval); realtimeUpdateInterval = setInterval(updateRealtimeInfo, 2000); } catch (e) { console.error("Failed to initialize dashboard:", e); document.getElementById('dashboard-loading').innerHTML = `<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load device info.</p>`; } }
async function updateRealtimeInfo() { const command = [ "cat /proc/meminfo", "head -n 1 /proc/stat", "dumpsys display | grep 'fps='", "dumpsys battery | grep -E 'level|status|temperature'" ].join(" && echo '---NEON_SPLIT---' && "); try { const output = await executeShellCommand(command, 'DeviceInfo', `realtime-${generateRandomId()}`); const parts = output.split('---NEON_SPLIT---\n'); const memInfo = parts[0] ?? ''; const memTotal = parseInt(memInfo.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0), memAvailable = parseInt(memInfo.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0); if (memTotal > 0) { const memUsed = memTotal - memAvailable, formatRam = (kb) => (kb / 1024 / 1024).toFixed(2); document.getElementById('ram-used').textContent = formatRam(memUsed); document.getElementById('ram-total').textContent = formatRam(memTotal); document.getElementById('ram-percent').textContent = ((memUsed / memTotal) * 100).toFixed(0); } const cpuStat = (parts[1] ?? '').split(/\s+/).slice(1).map(Number); if (cpuStat.length > 3) { const idle = cpuStat[3], total = cpuStat.reduce((a, b) => a + b, 0); const diffIdle = idle - cpuState.prevIdle, diffTotal = total - cpuState.prevTotal; const usage = diffTotal > 0 ? Math.max(0, Math.min(100, Math.round(100 * (1 - diffIdle / diffTotal)))) : 0; cpuState.prevIdle = idle; cpuState.prevTotal = total; document.getElementById('cpu-percent').textContent = usage; } const fpsInfo = parts[2] ?? ''; const fpsMatches = [...fpsInfo.matchAll(/fps=([\d.]+)/g)]; document.getElementById('fps-value').textContent = fpsMatches.length > 0 ? Math.round(Math.max(...fpsMatches.map(m => parseFloat(m[1])))) : '--'; const batteryInfo = parts[3] ?? ''; document.getElementById('battery-level').textContent = batteryInfo.match(/level: (\d+)/)?.[1] ?? '--'; document.getElementById('battery-temp').textContent = ((parseInt(batteryInfo.match(/temperature: (\d+)/)?.[1] ?? 0)) / 10).toFixed(1); document.getElementById('battery-status-icon').className = batteryInfo.match(/status: 2/)?.[0] ? 'fas fa-bolt charging' : 'fas fa-battery-three-quarters'; } catch (e) { console.error("Failed to update real-time info:", e); clearInterval(realtimeUpdateInterval); getAlpine().showNotification("Lost connection for real-time data."); } }
async function checkModuleExists(moduleName) { if (!window.Android?.checkFileExists) return false; try { const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh", exists = await window.Android.checkFileExists(`/storage/emulated/0/Download/com.fps.injector/${fileName}`); (exists ? downloadedModules.add : downloadedModules.delete).call(downloadedModules, moduleName); localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules])); return exists; } catch (e) { console.error("Error checking file existence:", e); return false; } }
async function loadData(key, url, elementId) { try { let data = JSON.parse(localStorage.getItem(key)); if (!data) { const response = await fetch(url, { cache: "no-store" }); if (!response.ok) throw new Error(`HTTP error! ${response.status}`); data = await response.json(); localStorage.setItem(key, JSON.stringify(data)); } return data; } catch (error) { console.error(`Error loading from ${url}:`, error); if(elementId) document.getElementById(elementId).innerHTML = `<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load. Check connection.</p>`; return null; } }
async function loadModules() { allModules = await loadData("cachedModules", MODULES_URL, "module-items"); if(allModules) { await Promise.all(allModules.map(m => checkModuleExists(m.name))); renderModules(allModules); } }
async function loadFpsModules() { allFpsModules = await loadData("cachedFpsModules", FPS_MODULES_URL, "fps-module-items"); if(allFpsModules) { await Promise.all(allFpsModules.map(m => checkModuleExists(m.name))); renderFpsModules(allFpsModules); } }
async function loadFakeDevices() { allFakeDevices = await loadData("cachedFakeDevices", FAKE_DEVICE_URL, "fake-device-items"); if(allFakeDevices) { await Promise.all(allFakeDevices.map(d => checkModuleExists(d.name))); renderFakeDevices(allFakeDevices); } }
async function loadCommands() { COMMANDS = await loadData("cachedCommands", COMMANDS_URL); RESTORE_COMMANDS = await loadData("cachedRestoreCommands", RESTORE_URL); }
function renderModules(modules) { const list = document.getElementById("module-items"); list.innerHTML = ""; const sorted = [...modules].sort((a,b) => a.name === "STOP MODULE" ? -1 : b.name === "STOP MODULE" ? 1 : 0); sorted.forEach(module => { const item = document.createElement("div"); item.className = "bg-gray-800/50 border-l-4 border-purple-500 p-2 rounded-lg mb-1"; if (module.name === "STOP MODULE") { item.innerHTML = `<button class="btn btn-primary w-full" onclick="handleModuleAction('STOP MODULE', '${module.url}')">Remove Modules</button>`; } else { item.className += " flex justify-between items-center"; item.innerHTML = `<div class="module-text-container"><span class="flex items-center gap-2 text-sm"><i class="fas fa-microchip text-emerald-400 text-sm"></i><span>${module.name}</span></span><p class="text-[10px] text-gray-400">${module.desc}</p></div><label class="switch"><input type="checkbox" ${activeModules.has(module.name) ? 'checked' : ''}><span class="slider"></span></label>`; item.querySelector('input').addEventListener("change", async (e) => { if (e.target.checked) { if (!(await checkShizukuStatus())) { getAlpine().showNotification("Shizuku is not running."); e.target.checked = false; return; } handleModuleAction(module.name, module.url); } else { if (await getAlpine().showConfirm(`Disable ${module.name}?`)) { activeModules.delete(module.name); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); renderModules(allModules); } else { e.target.checked = true; } } }); } list.appendChild(item); }); }
function renderFpsModules(modules) { const container = document.getElementById("fps-module-items"); container.innerHTML = ""; modules.filter(m => m.name !== "Stop Module").forEach(module => { const item = document.createElement("div"); item.className = "radio-item"; item.innerHTML = `<input type="radio" id="fps-${module.name.replace(/\s+/g, '-')}" name="fps-group" value="${module.name}" ${activeModules.has(module.name) ? 'checked' : ''}><label for="fps-${module.name.replace(/\s+/g, '-')}"><span class="flex-grow">${module.name}</span></label>`; container.appendChild(item); }); container.addEventListener('change', (e) => { if (e.target.type === 'radio') { const selectedName = e.target.value, module = allFpsModules.find(m => m.name === selectedName); if (module) { allFpsModules.forEach(m => activeModules.delete(m.name)); activeModules.add(selectedName); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); handleModuleAction(selectedName, module.url); } } }); }
function renderFakeDevices(devices) { const container = document.getElementById("fake-device-items"); container.innerHTML = ""; devices.filter(d => d.name !== "Restore Device").forEach(device => { const item = document.createElement("div"); item.className = "radio-item"; item.innerHTML = `<input type="radio" id="device-${device.name.replace(/\s+/g, '-')}" name="device-group" value="${device.name}" ${activeFakeDevices.has(device.name) ? 'checked' : ''}><label for="device-${device.name.replace(/\s+/g, '-')}"><span class="flex-grow">${device.name}</span></label>`; container.appendChild(item); }); container.addEventListener('change', (e) => { if (e.target.type === 'radio') { const selectedName = e.target.value, device = allFakeDevices.find(d => d.name === selectedName); if (device) { activeFakeDevices.clear(); activeFakeDevices.add(selectedName); localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices])); handleFakeDeviceAction(selectedName, device.url); } } }); }
function renderTweakComponents() { const createRadioOptions = (containerId, options, name) => { const container = document.getElementById(containerId); container.innerHTML = ''; options.forEach(opt => { const item = document.createElement("div"); item.className = "radio-item"; item.innerHTML = `<input type="radio" id="${name}-${opt.id}" name="${name}-group" value="${opt.value}" data-tweak="${name}"><label for="${name}-${opt.id}"><span class="flex-grow">${opt.name}</span></label>`; container.appendChild(item); }); }; createRadioOptions('renderer-options', [{ id: 'default', name: 'Default (OpenGL)', value: 'opengl' }, { id: 'skiagl', name: 'SkiaGL', value: 'skiagl' }, { id: 'skiavk', name: 'SkiaVK (Experimental)', value: 'skiavk' }], 'renderer'); }
function runCommandFlow(command, moduleName, metadata = {}) {
    window.isSilentTweak = false;
    window.commandMetadata = metadata; // Store metadata globally for runComplete
    getAlpine().modalMessage = "Loading Ad...";
    getAlpine().activeModal = 'processing';
    setTimeout(() => {
        if (!sessionStorage.getItem('adShownThisSession')) {
            sessionStorage.setItem('adShownThisSession', 'true');
            window.open('https://obqj2.com/4/9587058', '_blank');
        }
        window.currentCommand = command;
        fireAndForgetCommand(command, moduleName, generateRandomId());
    }, 5000); // UPDATED AD TIMER TO 5 SECONDS
}
function runTweakFlow(command, moduleName) { window.isSilentTweak = true; getAlpine().modalMessage = "Loading Ad..."; getAlpine().activeModal = 'processing'; setTimeout(() => { if (!sessionStorage.getItem('adShownThisSession')) { sessionStorage.setItem('adShownThisSession', 'true'); window.open('https://obqj2.com/4/9587058', '_blank'); } window.currentCommand = command; fireAndForgetCommand(command, moduleName, generateRandomId()); }, 5000); }
function fireAndForgetCommand(command, moduleName, logId) { if (!window.Android) { getAlpine().showNotification("Feature only available in the app."); getAlpine().activeModal = ''; return; } try { window.Android.executeCommand(command, moduleName, logId); if (moduleName !== "SilentOp") { getAlpine().modalMessage = `Executing ${moduleName}...`; getAlpine().activeModal = 'processing'; } } catch (e) { console.error(`Error firing command for ${moduleName}:`, e); getAlpine().showNotification(`Failed to start ${moduleName}.`); if (moduleName !== "SilentOp") window.runComplete(moduleName, false, logId); } }
function handleModuleAction(moduleName, moduleUrl) { const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh"; const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`; if (!downloadedModules.has(moduleName)) { showDownloadModal(moduleName, moduleUrl); return; } let runCommand = `sh ${modulePath} && rm ${modulePath}`; if (selectedGames.size > 0 && !moduleName.includes("STOP")) { const packageNames = [...selectedGames].map(gameName => allGames.find(g => g.nama_game === gameName)?.nama_paket).filter(Boolean); if (packageNames.length > 0) { runCommand = `sh ${modulePath} ${packageNames.join(' ')} && rm ${modulePath}`; } } runCommandFlow(runCommand, moduleName); }
function handleFakeDeviceAction(deviceName, deviceUrl) { const fileName = deviceName.replace(/[^a-zA-Z0-9]/g, '') + ".sh"; const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`; if (!downloadedModules.has(deviceName)) { showDownloadModal(deviceName, deviceUrl); } else { const runCommand = `sh ${modulePath} && rm ${modulePath}`; runCommandFlow(runCommand, deviceName); } }
async function handleRestore(moduleName, moduleUrl, stateSet, key, renderFunc, allData) { if (!(await checkShizukuStatus())) { getAlpine().showNotification("Shizuku is not running."); return; } const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh"; const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`; const action = async () => { const runCommand = `sh ${modulePath} && rm ${modulePath}`; runCommandFlow(runCommand, moduleName); stateSet.forEach(item => { if (allData.some(d => d.name === item)) stateSet.delete(item); }); localStorage.setItem(key, JSON.stringify([...stateSet])); renderFunc(allData); }; if (!downloadedModules.has(moduleName)) { showDownloadModal(moduleName, moduleUrl, action); } else { action(); } }
async function handleCustomModule() { const fileInput = document.getElementById("custom-module-input"), file = fileInput.files[0], button = document.getElementById("custom-module-btn"); const resetBtn = () => { fileInput.value = ''; button.textContent = "Select"; button.className = "btn btn-primary"; }; if (!file || !file.name.endsWith('.sh') || !window.Android || !(await checkShizukuStatus())) { getAlpine().showNotification("Please select a valid .sh file with Shizuku running."); resetBtn(); return; } const moduleName = file.name.replace(/\.sh$/, ''); if (activeModules.has(moduleName)) { getAlpine().showNotification("This module is already active."); resetBtn(); return; } activeModules.add(moduleName); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); const reader = new FileReader(); reader.onload = async (e) => { const filePath = `/storage/emulated/0/Download/com.fps.injector/${moduleName.replace(/[^a-zA-Z0-9]/g, '')}.sh`; await window.Android.saveCustomModule(e.target.result, filePath); let runCommand = `sh ${filePath} && rm ${filePath}`; if (selectedGames.size > 0) { const packageNames = [...selectedGames].map(gameName => allGames.find(g => g.nama_game === gameName)?.nama_paket).filter(Boolean); if (packageNames.length > 0) { runCommand = `sh ${filePath} ${packageNames.join(' ')} && rm ${filePath}`; } } runCommandFlow(runCommand, moduleName); }; reader.readAsText(file); }
async function handleCustomCommand() { const command = document.getElementById("custom-command-input").value.trim(); if (!command) return getAlpine().showNotification("Please enter a command."); if (!(await checkShizukuStatus())) return getAlpine().showNotification("Shizuku is not running."); runCommandFlow(command, "Custom Command"); }
function showDownloadModal(moduleName, moduleUrl, callback = null) { const alpine = getAlpine(); alpine.activeModal = 'download'; const progressBar = document.getElementById("modal-progress"), statusText = document.getElementById("modal-status"), title = document.getElementById("modal-title"); title.innerHTML = `<i class="fas fa-download mr-2"></i>Downloading ${moduleName}`; statusText.textContent = "Starting..."; progressBar.style.width = "0%"; window.downloadCallback = callback; let progress = 0; const interval = setInterval(() => { progress = Math.min(progress + 5, 90); progressBar.style.width = `${progress}%`; statusText.textContent = `Progress: ${progress}%`; }, 200); window.downloadingModuleInterval = interval; try { window.Android.downloadFile(moduleUrl, moduleName); } catch (e) { getAlpine().showNotification("Failed to start download."); alpine.activeModal = ''; clearInterval(interval); window.runComplete(moduleName, false, null); } }
function initializeDiagnosisChart() { const ctx = document.getElementById('diagnosis-chart').getContext('2d'); diagnosisChart = new Chart(ctx, { type: 'bar', data: { labels: [], datasets: [{ label: '% CPU Usage', data: [], backgroundColor: 'rgba(16, 185, 129, 0.5)', borderColor: 'rgba(16, 185, 129, 1)', borderWidth: 1 }] }, options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false, scales: { x: { beginAtZero: true, max: 100, ticks: { color: '#9ca3af' }, grid: { color: 'rgba(156, 163, 175, 0.1)' } }, y: { ticks: { color: '#9ca3af' }, grid: { display: false } } }, plugins: { legend: { display: false }, tooltip: { backgroundColor: '#030712', titleColor: '#34d399', bodyColor: '#f3f4f6' } } } }); }
function parseTopOutput(output) { try { const lines = output.split('\n'); const processLines = lines.slice(7); return processLines.map(line => { const parts = line.trim().split(/\s+/); if (parts.length < 10) return null; const cpuIndex = 8; const nameIndex = parts.length - 1; return { name: parts[nameIndex], cpu: parseFloat(parts[cpuIndex]) || 0 }; }).filter(p => p && p.name && p.cpu > 0.1).slice(0, 10); } catch { return []; } }
function updateDiagnosis(processes) { const alertDiv = document.getElementById('diagnosis-alert'); const highUsageProcess = processes.find(p => p.cpu > 40); if (highUsageProcess) { alertDiv.innerHTML = `<i class="fas fa-exclamation-triangle mr-2"></i><strong>High CPU Usage:</strong> <code>${highUsageProcess.name}</code> at <strong>${highUsageProcess.cpu.toFixed(1)}% CPU</strong> may cause slowdowns.`; alertDiv.className = 'diagnosis-alert'; } else { alertDiv.className = 'hidden'; } diagnosisChart.data.labels = processes.map(p => p.name); diagnosisChart.data.datasets[0].data = processes.map(p => p.cpu); diagnosisChart.update(); }
async function runDiagnosisCycle() { if (!COMMANDS.diagnose_realtime) return; try { const output = await executeShellCommand(COMMANDS.diagnose_realtime, 'SilentOp', `diag-${generateRandomId()}`); const processes = parseTopOutput(output); updateDiagnosis(processes); } catch (e) { console.error('Diagnosis cycle failed:', e); stopDiagnosis(); } }
function startDiagnosis() { if (diagnosisInterval || !diagnosisChart) return; runDiagnosisCycle(); diagnosisInterval = setInterval(runDiagnosisCycle, 3000); }
function stopDiagnosis() { clearInterval(diagnosisInterval); diagnosisInterval = null; }
function loadTweakSettings() { tweakSettings = JSON.parse(localStorage.getItem('tweakSettings')) || {}; }
function saveTweakSetting(key, value) { tweakSettings[key] = value; localStorage.setItem('tweakSettings', JSON.stringify(tweakSettings)); }
function applyStoredTweaks() { Object.keys(tweakSettings).forEach(key => { const value = tweakSettings[key]; const element = document.querySelector(`[data-tweak="${key}"][value="${value}"]`) || document.querySelector(`[data-tweak="${key}"]`); if (!element) return; if (element.type === 'radio') { element.checked = true; } else if (element.type === 'checkbox') { element.checked = value; } else if (element.type === 'range') { element.value = value; document.getElementById(`${element.id}-value`).textContent = value; } else if (element.type === 'number') { element.value = value; } }); }

// --- GAME & PERFORMANCE LOGIC (HEAVILY UPDATED) ---
async function loadPerformanceCommands() {
    PERFORMANCE_COMMANDS = await loadData("cachedPerfCommands", PERFORMANCE_JSON_URL);
    if (PERFORMANCE_COMMANDS && PERFORMANCE_COMMANDS.authorInfo) {
        populateAuthorInfo();
    }
}

function populateAuthorInfo() {
    const info = PERFORMANCE_COMMANDS.authorInfo;
    if (!info) return;
    document.getElementById('author-name').textContent = info.name;
    document.getElementById('ig-link').href = info.instagramUrl;
    document.getElementById('tt-link').href = info.tiktokUrl;
}

async function loadGames() {
    allGames = await loadData("cachedGames", GAME_JSON_URL, "game-lists");
    if (allGames) renderGames();
}

async function scanInstalledGames() {
    const loadingDiv = document.getElementById('game-scan-loading');
    const listsDiv = document.getElementById('game-lists');
    loadingDiv.classList.remove('hidden');
    listsDiv.classList.add('hidden');
    if (!(await checkShizukuStatus())) {
        getAlpine().showNotification("Shizuku is not running. Cannot scan games.");
        loadingDiv.classList.add('hidden');
        return;
    }
    try {
        const command = "pm list packages";
        const output = await executeShellCommand(command, 'SilentOp', `game-scan-${generateRandomId()}`);
        const installedPackages = new Set(output.split('\n').map(line => line.replace('package:', '').trim()));
        lastFoundGames = allGames.filter(game => installedPackages.has(game.nama_paket));
        renderGames(lastFoundGames);
    } catch (e) {
        console.error("Failed to scan for games:", e);
        getAlpine().showNotification("Error scanning for games.");
    } finally {
        loadingDiv.classList.add('hidden');
        listsDiv.classList.remove('hidden');
    }
}

function renderGames(foundGames = lastFoundGames) {
    const selectedList = document.getElementById("selected-games-list");
    const detectedList = document.getElementById("detected-games-list");
    selectedList.innerHTML = '';
    detectedList.innerHTML = '';

    const selectedGamesArray = allGames.filter(g => selectedGames.has(g.nama_game));
    const detectedUnselectedGames = foundGames.filter(g => !selectedGames.has(g.nama_game));

    const createGameItem = (game, isSelected) => {
        const item = document.createElement("div");
        item.className = "game-item";
        
        if (isSelected) {
            item.innerHTML = `
                <div class="game-item-header">
                    <div class="game-info">
                        <span>${game.nama_game}</span>
                        <small>by ${game.developer}</small>
                    </div>
                    <div class="game-actions">
                         <button onclick="removeGame('${game.nama_game}')" class="btn-remove" title="Remove Game"><i class="fas fa-times"></i></button>
                    </div>
                </div>
                <button onclick="boostGame('${game.nama_paket}', '${game.nama_game}')" class="btn-boost w-full mt-3">
                    <i class="fas fa-rocket mr-2"></i><span>Boost Performance</span>
                </button>
            `;
        } else {
             item.innerHTML = `
                <div class="game-item-header">
                    <div class="game-info">
                        <span>${game.nama_game}</span>
                        <small>by ${game.developer}</small>
                    </div>
                     <div class="game-actions">
                        <button onclick="addGame('${game.nama_game}')" class="btn-add" title="Add Game"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
            `;
        }
        return item;
    };

    if (selectedGamesArray.length > 0) {
        selectedGamesArray.forEach(game => selectedList.appendChild(createGameItem(game, true)));
    } else {
        selectedList.innerHTML = `<p class="text-sm text-gray-400">No games selected. Scan and add games below.</p>`;
    }

    if (detectedUnselectedGames.length > 0) {
        detectedUnselectedGames.forEach(game => detectedList.appendChild(createGameItem(game, false)));
    } else {
        detectedList.innerHTML = `<p class="text-sm text-gray-400">No other supported games found on your device.</p>`;
    }
}

function addGame(gameName) {
    selectedGames.add(gameName);
    localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
    renderGames(); 
    getAlpine().showNotification(`${gameName} added to list.`);
}

async function removeGame(gameName) {
    if (await getAlpine().showConfirm(`Remove ${gameName} from your list?`)) {
        selectedGames.delete(gameName);
        localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
        renderGames(); 
        getAlpine().showNotification(`${gameName} removed.`);
    }
}

function parseSystemStats(output) {
    const parts = output.split('---NEON_STATS_SPLIT---');
    const memInfo = parts[0];
    const storageInfo = parts[1];
    
    const ramAvailable = parseInt(memInfo.match(/MemAvailable:\s+(\d+)/)?.[1] || 0);
    
    let storageAvailable = 0;
    if (storageInfo) {
        const storageLines = storageInfo.split('\n');
        if (storageLines.length > 1) {
            const dataLine = storageLines[1].trim().split(/\s+/);
            storageAvailable = parseInt(dataLine[3] || 0);
        }
    }
    
    return { ramAvailable, storageAvailable };
}

function formatBytes(kiloBytes) {
    if (kiloBytes === 0) return '0 KB';
    const megaBytes = kiloBytes / 1024;
    if (megaBytes < 1024) {
        return megaBytes.toFixed(1) + ' MB';
    } else {
        const gigaBytes = megaBytes / 1024;
        return gigaBytes.toFixed(2) + ' GB';
    }
}

function displayBoostResults(before, after) {
    const ramCleaned = after.ramAvailable > before.ramAvailable ? after.ramAvailable - before.ramAvailable : 0;
    const storageCleaned = after.storageAvailable > before.storageAvailable ? after.storageAvailable - before.storageAvailable : 0;

    document.getElementById('ram-before').textContent = formatBytes(before.ramAvailable);
    document.getElementById('ram-after').textContent = formatBytes(after.ramAvailable);
    document.getElementById('ram-cleaned').textContent = `+${formatBytes(ramCleaned)}`;
    
    document.getElementById('storage-before').textContent = formatBytes(before.storageAvailable);
    document.getElementById('storage-after').textContent = formatBytes(after.storageAvailable);
    document.getElementById('storage-cleaned').textContent = `+${formatBytes(storageCleaned)}`;

    document.getElementById('boost-results-container').classList.remove('hidden');
}

async function boostGame(packageName, gameName) {
    if (!(await checkShizukuStatus())) {
        getAlpine().showNotification("Shizuku is not running.");
        return;
    }

    if (!PERFORMANCE_COMMANDS || !PERFORMANCE_COMMANDS.getSystemStats || !PERFORMANCE_COMMANDS.fullGameBoost) {
        getAlpine().showNotification("Performance commands not loaded. Check performance.json.");
        return;
    }

    try {
        getAlpine().showNotification("Gathering initial system stats...");
        const beforeOutput = await executeShellCommand(PERFORMANCE_COMMANDS.getSystemStats, "SilentOp", `stats-before-${generateRandomId()}`);
        boostState.before = parseSystemStats(beforeOutput);

        const commandTemplate = PERFORMANCE_COMMANDS.fullGameBoost;
        const finalCommand = commandTemplate.replace(/{packageName}/g, packageName);

        runCommandFlow(finalCommand, `Boosting ${gameName}`);
    } catch (e) {
        getAlpine().showNotification("Failed to start boost process.");
        console.error("Boost process failed:", e);
    }
}

window.onShellOutput = function(moduleName, output, logId) { const silentOps = ['DeviceInfo', 'SilentOp', 'DnsCheck']; if (!silentOps.includes(moduleName)) { const outEl = document.getElementById("cmd-output"); if (window.currentLogId !== logId) { outEl.innerHTML = ''; window.currentOutput = ''; window.currentLogId = logId; } window.currentOutput += output + "\n"; const line = document.createElement('span'); line.innerHTML = parseAnsiColors(output); outEl.appendChild(line); outEl.appendChild(document.createTextNode('\n')); outEl.scrollTop = outEl.scrollHeight; window.Android?.saveLog?.(window.currentOutput, logId); } };
window.downloadComplete = function(moduleName, success) { const alpine = getAlpine(); const progressBar = document.getElementById("modal-progress"), statusText = document.getElementById("modal-status"); clearInterval(window.downloadingModuleInterval); progressBar.style.width = success ? "100%" : "0%"; statusText.textContent = success ? "Complete!" : "Failed."; setTimeout(() => { if (alpine.activeModal === 'download') alpine.activeModal = ''; }, 500); if (success) { downloadedModules.add(moduleName); localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules])); getAlpine().showNotification(`${moduleName} downloaded!`); if (window.downloadCallback) { window.downloadCallback(); window.downloadCallback = null; } else { const module = allModules.find(m => m.name === moduleName) || allFpsModules.find(m => m.name === moduleName); const fakeDevice = allFakeDevices.find(d => d.name === moduleName); if (module) { handleModuleAction(module.name, module.url); } else if (fakeDevice) { handleFakeDeviceAction(fakeDevice.name, fakeDevice.url); } } } else { getAlpine().showNotification(`Download failed for ${moduleName}.`); window.runComplete(moduleName, false, null); } };

window.runComplete = async function(moduleName, success, logId) { // Now async
    const alpine = getAlpine();
    const silentOps = ['DeviceInfo', 'SilentOp', 'DnsCheck'];
    if (silentOps.includes(moduleName)) return;

    const timestamp = new Date().toLocaleString();
    let command = window.currentCommand || "";
    commandLogs.push({ command, output: window.currentOutput, timestamp, logId });
    localStorage.setItem("commandLogs", JSON.stringify(commandLogs));
    renderLogs();

    if (window.isSilentTweak) {
        alpine.activeModal = '';
    } else {
        alpine.activeModal = 'commandOutput';
    }

    if (success) {
        alpine.showNotification(`${moduleName} executed successfully!`);
        if (moduleName.includes('Boosting')) {
            try {
                getAlpine().showNotification("Gathering final results...");
                const afterOutput = await executeShellCommand(PERFORMANCE_COMMANDS.getSystemStats, "SilentOp", `stats-after-${generateRandomId()}`);
                const afterStats = parseSystemStats(afterOutput);
                displayBoostResults(boostState.before, afterStats);
                boostState = {}; // Reset state
            } catch (e) {
                console.error("Failed to get after-boost stats:", e);
                document.getElementById('boost-results-container').classList.add('hidden');
            }
            setTimeout(() => {
                alpine.activeModal = 'support';
            }, 1000);
        }
    } else {
        alpine.showNotification(`Failed to run ${moduleName}.`);
    }

    window.currentOutput = "";
    window.currentLogId = null;
    window.currentCommand = null;
    window.isSilentTweak = false;
};

function renderLogs() { ['custom'].forEach(tab => { const logPanel = document.getElementById(`log-list-${tab}`); if (!logPanel) return; logPanel.innerHTML = commandLogs.length === 0 ? `<p class="text-gray-400 text-sm"><i class="fas fa-info-circle mr-2"></i>No logs yet.</p>` : ""; [...commandLogs].reverse().forEach((log, i) => { const index = commandLogs.length - 1 - i, item = document.createElement("div"); item.className = "flex justify-between items-center bg-gray-800/50 border-l-4 border-purple-500 p-2 rounded-lg mb-1"; item.innerHTML = `<div class="flex flex-col"><span class="text-emerald-400 text-sm"><i class="fas fa-clock mr-2"></i>${log.timestamp}</span><p class="text-sm"><i class="fas fa-terminal mr-2"></i><strong>Command:</strong> ${log.command.length > 30 ? log.command.substring(0, 27) + '...' : log.command}</p></div><div class="flex gap-2"><button class="text-emerald-400 hover:text-emerald-300" onclick="viewLog(${index})"><i class="fas fa-eye"></i></button><button class="text-red-400 hover:text-red-300" onclick="deleteLog(${index})"><i class="fas fa-trash"></i></button></div>`; logPanel.appendChild(item); }); }); }
async function clearAllLogs() { const alpine = getAlpine(); if (await alpine.showConfirm("Are you sure you want to clear all logs?")) { if (window.Android?.deleteLog) { commandLogs.forEach(log => window.Android.deleteLog(log.logId)); } commandLogs = []; localStorage.setItem("commandLogs", "[]"); renderLogs(); alpine.showNotification("All logs cleared!"); } }
function viewLog(index) { const log = commandLogs[index], alpine = getAlpine(); alpine.activeModal = 'commandOutput'; setTimeout(() => { const outputEl = document.getElementById("cmd-output"); outputEl.innerHTML = `<div class="font-sans text-xs mb-2"><strong>Timestamp:</strong> ${log.timestamp}<br><strong>Command:</strong> ${log.command}</div><hr class="border-gray-600 my-2">${parseAnsiColors(log.output)}`; }, 0); }
async function deleteLog(index) { const alpine = getAlpine(); if (await alpine.showConfirm("Delete this log?")) { const log = commandLogs.splice(index, 1)[0]; if (window.Android?.deleteLog) window.Android.deleteLog(log.logId); localStorage.setItem("commandLogs", JSON.stringify(commandLogs)); renderLogs(); alpine.showNotification("Log deleted!"); } }

document.addEventListener('DOMContentLoaded', async () => {
    try {
        await loadCommands(); 
        loadTweakSettings();
        await Promise.all([
            loadModules(), 
            loadFpsModules(), 
            loadFakeDevices(), 
            loadGames(), 
            loadPerformanceCommands(), 
            checkForUpdates()
        ]);
        
        renderLogs(); renderTweakComponents(); initializeDiagnosisChart(); applyStoredTweaks();
        const shizukuOk = await checkShizukuStatus();
        if (shizukuOk) { await checkDnsStatus(); await initializeDashboard(); }
    } catch (error) { console.error("Initialization failed:", error); getAlpine().showNotification("App failed to initialize properly."); }

    const setupTweakRadioListener = (containerId, commandKey, moduleName) => { document.getElementById(containerId).addEventListener('change', e => { if (e.target.type !== 'radio') return; const value = e.target.value; const tweakId = e.target.dataset.tweak; const command = COMMANDS[commandKey].replace('{value}', value); saveTweakSetting(tweakId, value); runTweakFlow(command, moduleName); }); };
    const setupTweakSwitchListener = (switchId, tweakKey, commandOn, commandOff, moduleName) => { document.getElementById(switchId).addEventListener('change', e => { const command = e.target.checked ? COMMANDS[commandOn] : RESTORE_COMMANDS[commandOff]; saveTweakSetting(tweakKey, e.target.checked); runTweakFlow(command, moduleName); }); };
    
    setupTweakRadioListener('renderer-options', 'set_renderer', 'Graphics Renderer');
    setupTweakSwitchListener('thermal-switch', 'thermal', 'disable_thermal', 'restore_thermal', 'Thermal Control');
    setupTweakSwitchListener('power-mode-switch', 'power_mode', 'power_mode_performance', 'restore_power_mode', 'Power Mode');
    setupTweakSwitchListener('game-mode-switch', 'game_mode', 'game_mode_on', 'restore_game_mode', 'Game Mode');
    setupTweakSwitchListener('fps-unlocker-switch', 'fps_unlocker', 'fps_unlocker_on', 'restore_fps_unlocker', 'FPS Unlocker');
    setupTweakSwitchListener('background-limiter-switch', 'background_limiter', 'background_limiter_on', 'restore_background_limiter', 'Background Limiter');
    setupTweakSwitchListener('boot-optimizer-switch', 'boot_optimizer', 'boot_optimizer_on', 'restore_boot_optimizer', 'Boot Optimizer');
    setupTweakSwitchListener('vibration-switch', 'vibration_control', 'vibration_control_off', 'restore_vibration_control', 'Vibration Control');
    setupTweakSwitchListener('animation-speed-switch', 'animation_speed', 'animation_speed_fast', 'restore_animation_speed', 'Animation Speed');
    setupTweakSwitchListener('wifi-scan-switch', 'wifi_scan', 'disable_wifi_scan', 'restore_wifi_scan', 'Wi-Fi Scanning');
    setupTweakSwitchListener('gpu-rendering-switch', 'gpu_rendering', 'force_gpu_rendering', 'restore_gpu_rendering', 'GPU Rendering');
    setupTweakSwitchListener('tcp-handshake-switch', 'tcp_handshake', 'fast_tcp_handshake', 'restore_tcp_handshake', 'TCP Tweak');
    setupTweakSwitchListener('storage-trim-switch', 'storage_trim', 'daily_storage_trim', 'restore_storage_trim', 'Storage Trim');

    document.getElementById("set-dpi-btn").addEventListener("click", () => { const dpi = document.getElementById("dpi-input").value; if (!dpi) return; saveTweakSetting('dpi', dpi); runTweakFlow(COMMANDS.set_dpi.replace('{value}', dpi), 'DPI Changer'); });
    document.getElementById("reset-dpi-btn").addEventListener("click", () => { saveTweakSetting('dpi', ''); document.getElementById('dpi-input').value = ''; runTweakFlow(COMMANDS.reset_dpi, 'DPI Changer'); });
    
    const setupUtilityButton = (btnId, commandKey, moduleName) => {
        document.getElementById(btnId).addEventListener("click", () => {
             if (!PERFORMANCE_COMMANDS || !PERFORMANCE_COMMANDS[commandKey]) {
                const legacyCommand = COMMANDS[commandKey] || RESTORE_COMMANDS[commandKey];
                if(legacyCommand) { runCommandFlow(legacyCommand, moduleName); }
                else { getAlpine().showNotification("Utility commands not loaded."); }
                return;
            }
            runCommandFlow(PERFORMANCE_COMMANDS[commandKey], moduleName);
        });
    };
    setupUtilityButton('ram-cleaner-btn', 'utilityRamClean', 'RAM Cleaner');
    setupUtilityButton('clear-cache-btn', 'utilityStorageClean', 'Storage Cache Cleaner');
    setupUtilityButton('deep-sleep-btn', 'force_deep_sleep', 'Deep Sleep Utility');
    setupUtilityButton('log-cleaner-btn', 'log_cleaner', 'Log Cleaner');

    document.getElementById("restore-tweaks-btn").addEventListener("click", async () => { if (await getAlpine().showConfirm("Restore all tweaks to their default values? This action will reload the app.")) { runTweakFlow(Object.values(RESTORE_COMMANDS).join(' && '), "Restore All Tweaks"); localStorage.removeItem('tweakSettings'); setTimeout(() => location.reload(), 2500); } });
    document.getElementById("custom-module-btn").addEventListener("click", (e) => { if (e.currentTarget.textContent === "Select") document.getElementById("custom-module-input").click(); else handleCustomModule(); });
    document.getElementById("custom-module-input").addEventListener("change", (e) => { const btn = document.getElementById("custom-module-btn"); if (e.target.files.length && e.target.files[0].name.endsWith('.sh')) { btn.textContent = "Run"; btn.className = "btn bg-purple-600 text-white hover:bg-purple-500"; } });
    document.getElementById("restore-device-btn").addEventListener("click", () => { const module = allFakeDevices.find(d => d.name === "Restore Device"); if(module) handleRestore(module.name, module.url, activeFakeDevices, "activeFakeDevices", renderFakeDevices, allFakeDevices); });
    document.getElementById("restore-fps-btn").addEventListener("click", () => { const module = allFpsModules.find(m => m.name === "Stop Module"); if(module) handleRestore(module.name, module.url, activeModules, "activeModules", renderFpsModules, allFpsModules); });
    document.getElementById("run-custom-command-btn").addEventListener("click", handleCustomCommand);
    document.getElementById("clear-logs-btn-custom").addEventListener("click", clearAllLogs);
    
    document.getElementById("scan-games-btn").addEventListener("click", scanInstalledGames);
});