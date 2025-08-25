document.addEventListener('alpine:init', () => {
    Alpine.data('app', () => ({
        activeTab: 'home',
        sidebarOpen: false,
        activeModal: '',
        modalMessage: '',
        notification: { show: false, message: '' },
        confirmResolver: null,
        
        init() {
            this.$nextTick(() => this.updateNavIndicator());
        },
        
        setActiveTab(tab, event) {
            this.activeTab = tab;
            this.updateNavIndicator(event.currentTarget);
        },

        updateNavIndicator(target) {
            const indicator = document.getElementById('nav-indicator');
            if (!target) {
                target = this.$refs.nav.querySelector('.nav-item.active');
            }
            if (target) {
                indicator.style.width = `${target.offsetWidth}px`;
                indicator.style.left = `${target.offsetLeft}px`;
                
                document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
                target.classList.add('active');
            }
        },

        showConfirm(message) {
            this.modalMessage = message;
            this.activeModal = 'confirm';
            return new Promise(resolve => { this.confirmResolver = resolve; });
        },
        resolveConfirm(value) {
            this.confirmResolver?.(value);
            this.activeModal = '';
        },
        showNotification(message, duration = 3000) {
            this.notification.message = message;
            this.notification.show = true;
            setTimeout(() => { this.notification.show = false; }, duration);
        }
    }));
});

let realtimeUpdateInterval = null;
const cpuState = { prevIdle: 0, prevTotal: 0 };
const VERSION_URL = "version.json";

function getAlpine() { return document.body._x_dataStack[0]; }
function generateRandomId() { return Array.from({ length: 15 }, () => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.charAt(Math.floor(Math.random() * 62))).join(''); }
function parseAnsiColors(text) { const ansiMap = {'\x1B[0;31m': '<span class="ansi-red">', '\x1B[0;32m': '<span class="ansi-green">', '\x1B[0;36m': '<span class="ansi-cyan">', '\x1B[1;33m': '<span class="ansi-yellow">', '\x1B[0m': '</span>'}; let html = text.replace(/[&<>"']/g, m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[m]); return Object.entries(ansiMap).reduce((acc, [ansi, tag]) => acc.replace(new RegExp(ansi.replace(/\[/g, '\\['), 'g'), tag), html); }

const MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/refs/heads/main/Modules.json", FPS_MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/refs/heads/main/FpsSetting.json", FAKE_DEVICE_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/main/FakeDevice.json", GAME_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/refs/heads/main/Game.json", RESTORE_DEVICE_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/main/restoredevice.sh";
const downloadedModules = new Set(JSON.parse(localStorage.getItem("downloadedModules") || "[]")), activeModules = new Set(JSON.parse(localStorage.getItem("activeModules") || "[]")), activeFakeDevices = new Set(JSON.parse(localStorage.getItem("activeFakeDevices") || "[]")), selectedGames = new Set(JSON.parse(localStorage.getItem("selectedGames") || "[]"));
let commandLogs = JSON.parse(localStorage.getItem("commandLogs") || "[]");

async function loadAppVersion() { try { const version = window.Android?.getAppVersion ? await window.Android.getAppVersion() : "0.0.0"; document.getElementById("app-version").textContent = `Version: ${version || 'Unknown'}`; return version; } catch (e) { console.error("Error loading app version:", e); document.getElementById("app-version").textContent = "Version: Error"; return "0.0.0"; } }

async function checkShizukuStatus() {
    const statusEl = document.getElementById("shizuku-status");
    try {
        const status = window.Android?.getShizukuStatus ? await window.Android.getShizukuStatus() : false;
        statusEl.innerHTML = `<i class="fas ${status ? 'fa-check-circle' : 'fa-times-circle'}" style="color: ${status ? 'var(--color-primary-light)' : 'var(--color-error)'};"></i><span>Shizuku: ${status ? 'Running' : 'Not Running'}</span>`;
        statusEl.classList.remove('status-ok', 'status-error');
        statusEl.classList.add(status ? 'status-ok' : 'status-error');
        return status;
    } catch (e) {
        console.error("Error checking Shizuku status:", e);
        statusEl.innerHTML = `<i class="fas fa-exclamation-circle" style="color: #f59e0b;"></i><span>Shizuku: Error</span>`;
        statusEl.classList.remove('status-ok', 'status-error');
        return false;
    }
}

function compareVersions(v1, v2) { const p1 = v1.split('.').map(Number), p2 = v2.split('.').map(Number); for (let i = 0; i < Math.max(p1.length, p2.length); i++) { const n1 = p1[i] || 0, n2 = p2[i] || 0; if (n1 > n2) return 1; if (n1 < n2) return -1; } return 0; }
async function checkForUpdates() { try { const localVersion = await loadAppVersion(); if (localVersion === "0.0.0") return; const response = await fetch(VERSION_URL, { cache: "no-store" }); const data = await response.json(); if (compareVersions(data.latestVersion, localVersion) > 0) { document.getElementById('update-version').textContent = data.latestVersion; document.getElementById('update-notes').innerHTML = `<ul>${data.releaseNotes.map(note => `<li>${note}</li>`).join('')}</ul>`; getAlpine().activeModal = 'update'; } } catch (e) { console.error("Update check failed:", e); } }

function executeShellCommand(command, id) { return new Promise((resolve, reject) => { if (!window.Android?.executeCommand) return reject("Android interface not available."); let output = ""; const originalOnShellOutput = window.onShellOutput, originalRunComplete = window.runComplete; const cleanup = () => { window.onShellOutput = originalOnShellOutput; window.runComplete = originalRunComplete; }; window.onShellOutput = (moduleName, data, logId) => { if (logId === id) output += data + "\n"; else originalOnShellOutput?.(moduleName, data, logId); }; window.runComplete = (moduleName, success, logId) => { if (logId === id) { cleanup(); if (success) resolve(output.trim()); else reject("Command failed."); } else originalRunComplete?.(moduleName, success, logId); }; try { window.Android.executeCommand(command, 'DeviceInfo', id); } catch (e) { cleanup(); reject(e); } }); }

async function initializeDashboard() {
    if (!(await checkShizukuStatus())) { document.getElementById('dashboard-loading').innerHTML = `<p class="text-yellow-400 text-sm"><i class="fas fa-exclamation-triangle mr-2"></i>Shizuku not running. Cannot fetch live data.</p>`; return; }
    const command = [ "getprop ro.product.brand", "getprop ro.product.model", "getprop ro.product.cpu.abi", "getprop ro.build.version.sdk", "getprop ro.build.id", "[ $(su -c 'echo 1' 2>/dev/null) ] && echo 'Yes' || echo 'No'", "uptime -p" ].join(" && echo '---NEON_SPLIT---' && ");
    try {
        const output = await executeShellCommand(command, `static-${generateRandomId()}`);
        const parts = output.split('---NEON_SPLIT---\n');
        document.getElementById('device-name').textContent = `${parts[0] ?? '...'} ${parts[1] ?? '...'}`;
        document.getElementById('device-cpu-arch').textContent = parts[2] ?? '...';
        document.getElementById('device-sdk').textContent = parts[3] ?? '...';
        document.getElementById('device-build').textContent = parts[4] ?? '...';
        document.getElementById('device-root').textContent = parts[5] ?? '...';
        document.getElementById('device-uptime').textContent = (parts[6] ?? '...').replace('up ','');
        
        document.getElementById('dashboard-loading').style.display = 'none';
        document.getElementById('dashboard-grid').style.display = 'grid';
        
        await updateRealtimeInfo();
        if (realtimeUpdateInterval) clearInterval(realtimeUpdateInterval);
        realtimeUpdateInterval = setInterval(updateRealtimeInfo, 2000);
    } catch (e) { console.error("Failed to initialize dashboard:", e); document.getElementById('dashboard-loading').innerHTML = `<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load device info.</p>`; }
}
async function updateRealtimeInfo() {
    const command = [ "cat /proc/meminfo", "head -n 1 /proc/stat", "dumpsys display | grep 'fps='", "dumpsys battery | grep -E 'level|status|temperature'" ].join(" && echo '---NEON_SPLIT---' && ");
    try {
        const output = await executeShellCommand(command, `realtime-${generateRandomId()}`);
        const parts = output.split('---NEON_SPLIT---\n');
        
        const memInfo = parts[0] ?? ''; const memTotal = parseInt(memInfo.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0), memAvailable = parseInt(memInfo.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0);
        if (memTotal > 0) { const memUsed = memTotal - memAvailable, formatRam = (kb) => (kb / 1024 / 1024).toFixed(2); document.getElementById('ram-used').textContent = formatRam(memUsed); document.getElementById('ram-total').textContent = formatRam(memTotal); document.getElementById('ram-percent').textContent = ((memUsed / memTotal) * 100).toFixed(0); }
        
        const cpuStat = (parts[1] ?? '').split(/\s+/).slice(1).map(Number);
        if (cpuStat.length > 3) { const idle = cpuStat[3], total = cpuStat.reduce((a, b) => a + b, 0); const diffIdle = idle - cpuState.prevIdle, diffTotal = total - cpuState.prevTotal; const usage = diffTotal > 0 ? Math.max(0, Math.min(100, Math.round(100 * (1 - diffIdle / diffTotal)))) : 0; cpuState.prevIdle = idle; cpuState.prevTotal = total; document.getElementById('cpu-percent').textContent = usage; }
        
        const fpsInfo = parts[2] ?? ''; const fpsMatches = [...fpsInfo.matchAll(/fps=([\d.]+)/g)]; document.getElementById('fps-value').textContent = fpsMatches.length > 0 ? Math.round(Math.max(...fpsMatches.map(m => parseFloat(m[1])))) : '--';
        
        const batteryInfo = parts[3] ?? '';
        document.getElementById('battery-level').textContent = batteryInfo.match(/level: (\d+)/)?.[1] ?? '--';
        document.getElementById('battery-temp').textContent = ((parseInt(batteryInfo.match(/temperature: (\d+)/)?.[1] ?? 0)) / 10).toFixed(1);
        document.getElementById('battery-status-icon').className = batteryInfo.match(/status: 2/)?.[0] ? 'fas fa-bolt charging' : 'fas fa-battery-three-quarters';
    } catch (e) { console.error("Failed to update real-time info:", e); clearInterval(realtimeUpdateInterval); getAlpine().showNotification("Lost connection for real-time data."); }
}

async function checkModuleExists(moduleName) { if (!window.Android?.checkFileExists) return false; try { const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh", exists = await window.Android.checkFileExists(`/storage/emulated/0/Download/com.fps.injector/${fileName}`); (exists ? downloadedModules.add : downloadedModules.delete).call(downloadedModules, moduleName); localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules])); return exists; } catch (e) { console.error("Error checking file existence:", e); return false; } }
async function loadData(key, url, elementId) { try { let data = JSON.parse(localStorage.getItem(key)); if (!data) { const response = await fetch(url, { cache: "no-store" }); if (!response.ok) throw new Error(`HTTP error! ${response.status}`); data = await response.json(); localStorage.setItem(key, JSON.stringify(data)); } return data; } catch (error) { console.error(`Error loading from ${url}:`, error); document.getElementById(elementId).innerHTML = `<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load. Check connection.</p>`; return []; } }

async function loadModules() { allModules = await loadData("cachedModules", MODULES_URL, "module-items"); await Promise.all(allModules.map(m => checkModuleExists(m.name))); renderModules(allModules); }
async function loadFpsModules() { allFpsModules = await loadData("cachedFpsModules", FPS_MODULES_URL, "fps-module-items"); await Promise.all(allFpsModules.map(m => checkModuleExists(m.name))); renderFpsModules(allFpsModules); }
async function loadFakeDevices() { allFakeDevices = await loadData("cachedFakeDevices", FAKE_DEVICE_URL, "fake-device-items"); await Promise.all(allFakeDevices.map(d => checkModuleExists(d.name))); renderFakeDevices(allFakeDevices); }
async function loadGames() { allGames = await loadData("cachedGames", GAME_URL, "game-items"); renderGames(allGames); }

function renderModules(modules) {
    const list = document.getElementById("module-items"); list.innerHTML = "";
    const sorted = [...modules].sort((a,b) => a.name === "STOP MODULE" ? -1 : b.name === "STOP MODULE" ? 1 : 0);
    sorted.forEach(module => {
        const item = document.createElement("div"); item.className = "bg-gray-800/50 border-l-4 border-purple-500 p-2 rounded-lg mb-1";
        if (module.name === "STOP MODULE") {
            item.innerHTML = `<button class="btn btn-primary w-full" onclick="handleModuleAction('STOP MODULE', '${module.url}')">Remove Modules</button>`;
        } else {
            item.className += " flex justify-between items-center";
            item.innerHTML = `<div class="module-text-container"><span class="flex items-center gap-2 text-sm"><i class="fas fa-microchip text-emerald-400 text-sm"></i><span>${module.name}</span></span><p class="text-[10px] text-gray-400">${module.desc}</p></div><label class="switch"><input type="checkbox" ${activeModules.has(module.name) ? 'checked' : ''}><span class="slider"></span></label>`;
            item.querySelector('input').addEventListener("change", async (e) => {
                if (e.target.checked) {
                    if (!(await checkShizukuStatus())) { getAlpine().showNotification("Shizuku is not running."); e.target.checked = false; return; }
                    handleModuleAction(module.name, module.url);
                }
                else { if (await getAlpine().showConfirm(`Disable ${module.name}?`)) { activeModules.delete(module.name); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); renderModules(allModules); } else { e.target.checked = true; } }
            });
        }
        list.appendChild(item);
    });
}
function renderFpsModules(modules) {
    const container = document.getElementById("fps-module-items"); container.innerHTML = "";
    modules.filter(m => m.name !== "Stop Module").forEach(module => {
        const item = document.createElement("div"); item.className = "radio-item";
        item.innerHTML = `<input type="radio" id="fps-${module.name.replace(/\s+/g, '-')}" name="fps-group" value="${module.name}" ${activeModules.has(module.name) ? 'checked' : ''}><label for="fps-${module.name.replace(/\s+/g, '-')}"><span class="flex-grow">${module.name}</span></label>`;
        container.appendChild(item);
    });
    container.addEventListener('change', (e) => {
        if (e.target.type === 'radio') {
            const selectedName = e.target.value, module = allFpsModules.find(m => m.name === selectedName);
            if (module) {
                allFpsModules.forEach(m => activeModules.delete(m.name)); activeModules.add(selectedName);
                localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                handleModuleAction(selectedName, module.url);
            }
        }
    });
}
function renderFakeDevices(devices) {
    const container = document.getElementById("fake-device-items"); container.innerHTML = "";
    devices.filter(d => d.name !== "Restore Device").forEach(device => {
        const item = document.createElement("div"); item.className = "radio-item";
        item.innerHTML = `<input type="radio" id="device-${device.name.replace(/\s+/g, '-')}" name="device-group" value="${device.name}" ${activeFakeDevices.has(device.name) ? 'checked' : ''}><label for="device-${device.name.replace(/\s+/g, '-')}"><span class="flex-grow">${device.name}</span></label>`;
        container.appendChild(item);
    });
    container.addEventListener('change', (e) => {
        if (e.target.type === 'radio') {
            const selectedName = e.target.value, device = allFakeDevices.find(d => d.name === selectedName);
            if (device) {
                activeFakeDevices.clear(); activeFakeDevices.add(selectedName);
                localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
                handleFakeDeviceAction(selectedName, device.url);
            }
        }
    });
}
function renderGames(games) {
    const list = document.getElementById("game-items"); list.innerHTML = "";
    games.forEach(game => {
        const item = document.createElement("div"); item.className = "bg-gray-800/50 border-l-4 border-purple-500 p-2 rounded-lg mb-1 flex justify-between items-center";
        item.innerHTML = `<div class="module-text-container"><span class="flex items-center gap-2 text-sm"><i class="fas fa-gamepad text-emerald-400 text-sm"></i><span>${game.game}</span></span></div><label class="switch"><input type="checkbox" ${selectedGames.has(game.game) ? 'checked' : ''}><span class="slider"></span></label>`;
        item.querySelector('input').addEventListener("change", async (e) => {
            const action = e.target.checked ? selectedGames.add.bind(selectedGames) : selectedGames.delete.bind(selectedGames);
            if (!e.target.checked && !(await getAlpine().showConfirm(`Disable optimization for ${game.game}?`))) { e.target.checked = true; return; }
            action(game.game);
            localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
            if (e.target.checked && !(await checkShizukuStatus())) { getAlpine().showNotification("Shizuku is not running."); e.target.checked = false; selectedGames.delete(game.game); localStorage.setItem("selectedGames", JSON.stringify([...selectedGames])); return; }
            if (e.target.checked) handleGameAction(game.game, game.command);
        });
        list.appendChild(item);
    });
}

function runAdFlowAndExecute(executionFunc) { const alpine = getAlpine(); alpine.modalMessage = "Loading Ad..."; alpine.activeModal = 'processing'; setTimeout(() => { window.open('https://obqj2.com/4/9587058', '_blank'); executionFunc(); }, 1500); }
function fireAndForgetCommand(command, moduleName, logId) { if (!window.Android) { getAlpine().showNotification("Feature only available in the app."); return; } try { window.Android.executeCommand(command, moduleName, logId); getAlpine().modalMessage = `Executing ${moduleName}...`; getAlpine().activeModal = 'processing'; } catch (e) { console.error(`Error firing command for ${moduleName}:`, e); getAlpine().showNotification(`Failed to start ${moduleName}.`); window.runComplete(moduleName, false, logId); } }

function handleModuleAction(moduleName, moduleUrl) {
    const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
    const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;

    if (!downloadedModules.has(moduleName)) {
        showDownloadModal(moduleName, moduleUrl);
        return;
    }

    const executionFunc = () => {
        let runCommand = `sh ${modulePath}`;
        if (selectedGames.size > 0 && !moduleName.includes("STOP") && moduleName !== "Stop Module") {
            const packageNames = [...selectedGames].map(game => allGames.find(g => g.game === game)?.command.match(/\+([\w.]+)/)?.[1]).filter(Boolean);
            if (packageNames.length > 0) runCommand += ` ${packageNames.join(' ')}`;
        }
        const logId = generateRandomId();
        window.currentLogId = logId;
        window.currentOutput = "";
        fireAndForgetCommand(runCommand, moduleName, logId);
    };

    runAdFlowAndExecute(executionFunc);
}

function handleFakeDeviceAction(deviceName, deviceUrl) {
    const fileName = deviceName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
    const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;

    if (!downloadedModules.has(deviceName)) {
        showDownloadModal(deviceName, deviceUrl);
    } else {
        const executionFunc = () => {
            const logId = generateRandomId();
            window.currentLogId = logId;
            window.currentOutput = "";
            fireAndForgetCommand(`sh ${modulePath}`, deviceName, logId);
        };
        runAdFlowAndExecute(executionFunc);
    }
}

function handleGameAction(gameName, gameCommand) {
    const executionFunc = () => {
        const logId = generateRandomId();
        window.currentLogId = logId;
        window.currentOutput = "";
        fireAndForgetCommand(gameCommand, gameName, logId);
    };
    runAdFlowAndExecute(executionFunc);
}

async function handleRestore(moduleName, moduleUrl, stateSet, key, renderFunc, allData) {
    if (!(await checkShizukuStatus())) {
        getAlpine().showNotification("Shizuku is not running.");
        return;
    }

    const actionAndStateUpdate = () => {
        const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
        const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
        const logId = generateRandomId();
        window.currentLogId = logId;
        window.currentOutput = "";
        fireAndForgetCommand(`sh ${modulePath}`, moduleName, logId);
        
        stateSet.forEach(item => {
            if (allData.some(d => d.name === item)) stateSet.delete(item);
        });
        localStorage.setItem(key, JSON.stringify([...stateSet]));
        renderFunc(allData);
    };

    if (!downloadedModules.has(moduleName)) {
        showDownloadModal(moduleName, moduleUrl);
    } else {
        runAdFlowAndExecute(actionAndStateUpdate);
    }
}

async function handleCustomModule() { const fileInput = document.getElementById("custom-module-input"), file = fileInput.files[0], button = document.getElementById("custom-module-btn"); const resetBtn = () => { fileInput.value = ''; button.textContent = "Select"; button.className = "btn btn-primary"; }; if (!file || !file.name.endsWith('.sh') || !window.Android || !(await checkShizukuStatus())) { getAlpine().showNotification("Please select a valid .sh file with Shizuku running."); resetBtn(); return; } const moduleName = file.name.replace(/\.sh$/, ''); if (activeModules.has(moduleName)) { getAlpine().showNotification("This module is already active."); resetBtn(); return; } runAdFlowAndExecute(() => { activeModules.add(moduleName); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); const reader = new FileReader(); reader.onload = async (e) => { const filePath = `/storage/emulated/0/Download/com.fps.injector/${moduleName.replace(/[^a-zA-Z0-9]/g, '')}.sh`; await window.Android.saveCustomModule(e.target.result, filePath); let runCommand = `sh ${filePath}`; if (selectedGames.size > 0) { const packageNames = [...selectedGames].map(game => allGames.find(g => g.game === game)?.command.match(/\+([\w.]+)/)?.[1]).filter(Boolean); if (packageNames.length > 0) runCommand += ` ${packageNames.join(' ')}`; } fireAndForgetCommand(runCommand, moduleName, generateRandomId()); }; reader.readAsText(file); }); }
async function handleCustomCommand() { const command = document.getElementById("custom-command-input").value.trim(); if (!command || !window.Android || !(await checkShizukuStatus())) { getAlpine().showNotification("Please enter a command and ensure Shizuku is running."); return; } window.currentCommand = command; runAdFlowAndExecute(() => fireAndForgetCommand(command, "Custom Command", generateRandomId())); }
function showDownloadModal(moduleName, moduleUrl) { const alpine = getAlpine(); alpine.activeModal = 'download'; const progressBar = document.getElementById("modal-progress"), statusText = document.getElementById("modal-status"), title = document.getElementById("modal-title"); title.innerHTML = `<i class="fas fa-download mr-2"></i>Downloading ${moduleName}`; statusText.textContent = "Starting..."; progressBar.style.width = "0%"; let progress = 0; const interval = setInterval(() => { progress = Math.min(progress + 5, 90); progressBar.style.width = `${progress}%`; statusText.textContent = `Progress: ${progress}%`; }, 200); window.downloadingModuleInterval = interval; try { window.Android.downloadFile(moduleUrl, moduleName); } catch (e) { getAlpine().showNotification("Failed to start download."); alpine.activeModal = ''; clearInterval(interval); window.runComplete(moduleName, false, null); } }
window.onShellOutput = function(moduleName, output, logId) { if (moduleName !== 'DeviceInfo') { const outEl = document.getElementById("cmd-output"); if (window.currentLogId !== logId) { outEl.innerHTML = ''; window.currentOutput = ''; window.currentLogId = logId; } window.currentOutput += output + "\n"; const line = document.createElement('span'); line.innerHTML = parseAnsiColors(output); outEl.appendChild(line); outEl.appendChild(document.createTextNode('\n')); outEl.scrollTop = outEl.scrollHeight; window.Android?.saveLog?.(window.currentOutput, logId); } };

window.downloadComplete = function(moduleName, success) {
    const alpine = getAlpine();
    const progressBar = document.getElementById("modal-progress"), statusText = document.getElementById("modal-status");
    clearInterval(window.downloadingModuleInterval);
    progressBar.style.width = success ? "100%" : "0%";
    statusText.textContent = success ? "Complete!" : "Failed.";
    setTimeout(() => { if (alpine.activeModal === 'download') alpine.activeModal = ''; }, 500);

    if (success) {
        downloadedModules.add(moduleName);
        localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules]));
        getAlpine().showNotification(`${moduleName} downloaded!`);

        const module = allModules.find(m => m.name === moduleName) || allFpsModules.find(m => m.name === moduleName);
        const fakeDevice = allFakeDevices.find(d => d.name === moduleName);
        
        if (module) {
            handleModuleAction(module.name, module.url);
        } else if (fakeDevice) {
            handleFakeDeviceAction(fakeDevice.name, fakeDevice.url);
        }
    } else {
        getAlpine().showNotification(`Download failed for ${moduleName}.`);
        window.runComplete(moduleName, false, null);
    }
};

window.runComplete = function(moduleName, success, logId) { if (moduleName === 'DeviceInfo') return; getAlpine().activeModal = 'commandOutput'; const timestamp = new Date().toLocaleString(), fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh"; let command = `sh .../${fileName}`; if (moduleName === "Custom Command") command = window.currentCommand || ""; commandLogs.push({ command, output: window.currentOutput, timestamp, logId }); localStorage.setItem("commandLogs", JSON.stringify(commandLogs)); renderLogs(); if (success) { getAlpine().showNotification(`${moduleName} executed successfully!`); if (activeFakeDevices.has(moduleName) || moduleName === "Restore Device") initializeDashboard(); if (moduleName === "Custom Command") document.getElementById("custom-command-input").value = ''; } else { getAlpine().showNotification(`Failed to run ${moduleName}.`); if(activeModules.has(moduleName)) { activeModules.delete(moduleName); localStorage.setItem("activeModules", JSON.stringify([...activeModules])); renderModules(allModules); renderFpsModules(allFpsModules); } if(activeFakeDevices.has(moduleName)) { activeFakeDevices.delete(moduleName); localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices])); renderFakeDevices(allFakeDevices); } } window.currentOutput = ""; window.currentLogId = null; window.currentCommand = null; if (moduleName.includes("Custom Module")) { const btn = document.getElementById("custom-module-btn"); document.getElementById("custom-module-input").value = ''; btn.textContent = "Select"; btn.className = "btn btn-primary"; } };
function renderLogs() { ['home', 'custom', 'performance', 'game'].forEach(tab => { const logPanel = document.getElementById(`log-list-${tab}`); if (!logPanel) return; logPanel.innerHTML = commandLogs.length === 0 ? `<p class="text-gray-400 text-sm"><i class="fas fa-info-circle mr-2"></i>No logs yet.</p>` : ""; [...commandLogs].reverse().forEach((log, i) => { const index = commandLogs.length - 1 - i, item = document.createElement("div"); item.className = "flex justify-between items-center bg-gray-800/50 border-l-4 border-purple-500 p-2 rounded-lg mb-1"; item.innerHTML = `<div class="flex flex-col"><span class="text-emerald-400 text-sm"><i class="fas fa-clock mr-2"></i>${log.timestamp}</span><p class="text-sm"><i class="fas fa-terminal mr-2"></i><strong>Command:</strong> ${log.command.length > 30 ? log.command.substring(0, 27) + '...' : log.command}</p></div><div class="flex gap-2"><button class="text-emerald-400 hover:text-emerald-300" onclick="viewLog(${index})"><i class="fas fa-eye"></i></button><button class="text-red-400 hover:text-red-300" onclick="deleteLog(${index})"><i class="fas fa-trash"></i></button></div>`; logPanel.appendChild(item); }); }); }
async function clearAllLogs() { const alpine = getAlpine(); if (await alpine.showConfirm("Clear all logs?")) { if (window.Android?.deleteLog) { commandLogs.forEach(log => window.Android.deleteLog(log.logId)); } commandLogs = []; localStorage.setItem("commandLogs", "[]"); renderLogs(); alpine.showNotification("All logs cleared!"); } }
function viewLog(index) { const log = commandLogs[index], alpine = getAlpine(); alpine.activeModal = 'commandOutput'; setTimeout(() => { const outputEl = document.getElementById("cmd-output"); outputEl.innerHTML = `<div class="font-sans text-xs mb-2"><strong>Timestamp:</strong> ${log.timestamp}<br><strong>Command:</strong> ${log.command}</div><hr class="border-gray-600 my-2">${parseAnsiColors(log.output)}`; }, 0); }
async function deleteLog(index) { const alpine = getAlpine(); if (await alpine.showConfirm("Delete this log?")) { const log = commandLogs.splice(index, 1)[0]; if (window.Android?.deleteLog) window.Android.deleteLog(log.logId); localStorage.setItem("commandLogs", JSON.stringify(commandLogs)); renderLogs(); alpine.showNotification("Log deleted!"); } }

document.addEventListener('DOMContentLoaded', () => {
    Promise.all([loadModules(), loadFpsModules(), loadFakeDevices(), loadGames(), checkForUpdates()]);
    renderLogs(); initializeDashboard();
    document.getElementById("custom-module-btn").addEventListener("click", (e) => { if (e.currentTarget.textContent === "Select") document.getElementById("custom-module-input").click(); else handleCustomModule(); });
    document.getElementById("custom-module-input").addEventListener("change", (e) => { const btn = document.getElementById("custom-module-btn"); if (e.target.files.length && e.target.files[0].name.endsWith('.sh')) { btn.textContent = "Run"; btn.className = "btn bg-purple-600 text-white hover:bg-purple-500"; } });
    document.getElementById("restore-device-btn").addEventListener("click", () => { const module = allFakeDevices.find(d => d.name === "Restore Device"); if(module) handleRestore(module.name, module.url, activeFakeDevices, "activeFakeDevices", renderFakeDevices, allFakeDevices); });
    document.getElementById("restore-fps-btn").addEventListener("click", () => { const module = allFpsModules.find(m => m.name === "Stop Module"); if(module) handleRestore(module.name, module.url, activeModules, "activeModules", renderFpsModules, allFpsModules); });
    document.getElementById("run-custom-command-btn").addEventListener("click", handleCustomCommand);
    document.querySelectorAll("#clear-logs-btn, #clear-logs-btn-custom, #clear-logs-btn-performance, #clear-logs-btn-game").forEach(btn => btn.addEventListener("click", clearAllLogs));
});