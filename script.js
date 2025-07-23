let confirmResolver;

function showConfirmation(message) {
    const modal = document.getElementById("confirmation-modal");
    document.getElementById("confirmation-message").textContent = message;
    modal.style.display = "flex";
    return new Promise(resolve => { confirmResolver = resolve; });
}

document.getElementById("confirm-yes").addEventListener("click", () => {
    document.getElementById("confirmation-modal").style.display = "none";
    if (confirmResolver) confirmResolver(true);
});

document.getElementById("confirm-no").addEventListener("click", () => {
    document.getElementById("confirmation-modal").style.display = "none";
    if (confirmResolver) confirmResolver(false);
});

function showNotification(message, duration = 3000) {
    const notification = document.getElementById("notification");
    notification.textContent = message;
    notification.style.display = "block";
    setTimeout(() => { notification.style.display = "none"; }, duration);
}

function generateRandomId() {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return Array(15).fill().map(() => characters.charAt(Math.floor(Math.random() * characters.length))).join('');
}

function parseAnsiColors(text) {
    const ansiMap = {
        '\x1B[0;31m': '<span class="ansi-red">',
        '\x1B[0;32m': '<span class="ansi-green">',
        '\x1B[0;36m': '<span class="ansi-cyan">',
        '\x1B[1;33m': '<span class="ansi-yellow">',
        '\x1B[0m': '</span>'
    };
    let result = text.replace(/[&<>"']/g, m => ({ '&': '&', '<': '<', '>': '>', '"': '"', "'": '\'' })[m]);
    for (const [ansi, html] of Object.entries(ansiMap)) {
        result = result.replace(new RegExp(ansi.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&'), 'g'), html);
    }
    return result;
}

const MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/refs/heads/main/Modules.json";
const FPS_MODULES_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/refs/heads/main/FpsSetting.json";
const FAKE_DEVICE_URL = "https://raw.githubusercontent.com/AgungDevlop/Viral/main/FakeDevice.json";
const GAME_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/refs/heads/main/Game.json";
const RESTORE_DEVICE_URL = "https://raw.githubusercontent.com/AgungDevlop/Neon-Modules/main/restoredevice.sh";
const downloadedModules = new Set(JSON.parse(localStorage.getItem("downloadedModules") || "[]"));
const activeModules = new Set(JSON.parse(localStorage.getItem("activeModules") || "[]"));
const activeFakeDevices = new Set(JSON.parse(localStorage.getItem("activeFakeDevices") || "[]"));
const selectedGames = new Set(JSON.parse(localStorage.getItem("selectedGames") || "[]"));
let commandLogs = JSON.parse(localStorage.getItem("commandLogs") || "[]");

async function loadAppVersion() {
    try {
        const version = window.Android?.getAppVersion ? await window.Android.getAppVersion() : "N/A (WebView)";
        document.getElementById("app-version").textContent = `Version: ${version || 'Unknown'}`;
    } catch (e) {
        console.error("Error loading app version:", e);
        document.getElementById("app-version").textContent = "Version: Error";
    }
}

async function checkShizukuStatus() {
    try {
        const status = window.Android?.getShizukuStatus ? await window.Android.getShizukuStatus() : false;
        document.getElementById("shizuku-status").innerHTML = `
            <i class="fas ${status ? 'fa-check-circle' : 'fa-times-circle'}" style="color: ${status ? '#26a69a' : '#ef5350'};"></i>
            <span>Shizuku: ${status ? 'Running' : 'Not Running'}</span>`;
        return status;
    } catch (e) {
        console.error("Error checking Shizuku status:", e);
        document.getElementById("shizuku-status").innerHTML = `
            <i class="fas fa-exclamation-circle" style="color: #ef5350;"></i>
            <span>Shizuku: Error</span>`;
        return false;
    }
}

async function loadDeviceInfo() {
    try {
        if (window.Android?.getDeviceInfo) {
            const info = await window.Android.getDeviceInfo();
            const deviceInfo = JSON.parse(info);
            document.getElementById("device-info").innerHTML = `
                <p class="text-sm"><strong>Device:</strong> ${deviceInfo.brand || 'Unknown'} ${deviceInfo.model || 'Unknown'}</p>
                <p class="text-sm"><strong>CPU:</strong> ${deviceInfo.cpu || 'Unknown'}</p>
                <p class="text-sm"><strong>SDK:</strong> ${deviceInfo.sdk || 'Unknown'}</p>
                <p class="text-sm"><strong>Build:</strong> ${deviceInfo.build || 'Unknown'}</p>
                <p class="text-sm"><strong>Root:</strong> ${deviceInfo.root || 'Unknown'}</p>
            `;
        } else {
            document.getElementById("device-info").innerHTML = `<p class="text-gray-300 text-sm"><i class="fas fa-info-circle mr-2"></i>Device info not available.</p>`;
        }
    } catch (e) {
        console.error("Error loading device info:", e);
        document.getElementById("device-info").innerHTML = `<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load device info.</p>`;
    }
}

async function checkModuleExists(moduleName) {
    try {
        if (window.Android?.checkFileExists) {
            const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
            const exists = await window.Android.checkFileExists(`/storage/emulated/0/Download/com.fps.injector/${fileName}`);
            if (exists && !downloadedModules.has(moduleName)) {
                downloadedModules.add(moduleName);
                localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules]));
            } else if (!exists && downloadedModules.has(moduleName)) {
                downloadedModules.delete(moduleName);
                localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules]));
            }
            return exists;
        }
        return false;
    } catch (e) {
        console.error("Error checking file existence:", e);
        return false;
    }
}

let allModules = [];
let allFpsModules = [];
let allFakeDevices = [];
let allGames = [];
async function loadModules() {
    try {
        if (!allModules.length) {
            let modules = JSON.parse(localStorage.getItem("cachedModules"));
            if (!modules) {
                const response = await fetch(MODULES_URL, { cache: "no-store" });
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                modules = await response.json();
                localStorage.setItem("cachedModules", JSON.stringify(modules));
            }
            allModules = modules;
        }
        for (const module of allModules) await checkModuleExists(module.name);
        renderModules(allModules);
    } catch (error) {
        console.error("Error loading performance modules:", error);
        document.getElementById("module-items").innerHTML = '<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load performance modules. Check your internet connection.</p>';
    }
}

async function loadFpsModules() {
    try {
        if (!allFpsModules.length) {
            let fpsModules = JSON.parse(localStorage.getItem("cachedFpsModules"));
            if (!fpsModules) {
                const response = await fetch(FPS_MODULES_URL, { cache: "no-store" });
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                fpsModules = await response.json();
                localStorage.setItem("cachedFpsModules", JSON.stringify(fpsModules));
            }
            allFpsModules = fpsModules;
        }
        for (const module of allFpsModules) await checkModuleExists(module.name);
        renderFpsModules(allFpsModules);
    } catch (error) {
        console.error("Error loading FPS modules:", error);
        document.getElementById("fps-module-items").innerHTML = '<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load FPS modules. Check your internet connection.</p>';
    }
}

async function loadFakeDevices() {
    try {
        if (!allFakeDevices.length) {
            let fakeDevices = JSON.parse(localStorage.getItem("cachedFakeDevices"));
            if (!fakeDevices) {
                const response = await fetch(FAKE_DEVICE_URL, { cache: "no-store" });
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                fakeDevices = await response.json();
                localStorage.setItem("cachedFakeDevices", JSON.stringify(fakeDevices));
            }
            allFakeDevices = fakeDevices;
        }
        for (const device of allFakeDevices) await checkModuleExists(device.name);
        renderFakeDevices(allFakeDevices);
    } catch (error) {
        console.error("Error loading fake device modules:", error);
        document.getElementById("fake-device-items").innerHTML = '<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load fake device modules. Check your internet connection.</p>';
    }
}

async function loadGames() {
    try {
        if (!allGames.length) {
            let games = JSON.parse(localStorage.getItem("cachedGames"));
            if (!games) {
                const response = await fetch(GAME_URL, { cache: "no-store" });
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                games = await response.json();
                localStorage.setItem("cachedGames", JSON.stringify(games));
            }
            allGames = games;
        }
        renderGames(allGames);
    } catch (error) {
        console.error("Error loading games:", error);
        document.getElementById("game-items").innerHTML = '<p class="text-red-400 text-sm"><i class="fas fa-exclamation-circle mr-2"></i>Failed to load games. Check your internet connection.</p>';
    }
}

function renderModules(modules) {
    const moduleList = document.getElementById("module-items");
    moduleList.innerHTML = "";
    const stopModule = modules.find(module => module.name === "STOP MODULE");
    const otherModules = modules.filter(module => module.name !== "STOP MODULE");
    const sortedModules = stopModule ? [stopModule, ...otherModules] : otherModules;
    sortedModules.forEach((module, index) => {
        const isActive = activeModules.has(module.name);
        const isDownloaded = downloadedModules.has(module.name);
        const moduleItem = document.createElement("div");
        moduleItem.className = "bg-gray-800/50 border-l-4 border-purple-600 p-2 rounded-lg mb-1";
        if (index === 0 && module.name === "STOP MODULE") {
            moduleItem.innerHTML = `
                <button id="btn-remove-modules" 
                        class="w-full px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400"
                        onclick="handleModuleAction('STOP MODULE', '${module.url}')">
                    Remove Modules
                </button>
            `;
        } else {
            moduleItem.className += " flex justify-between items-center";
            moduleItem.innerHTML = `
                <div class="module-text-container flex-grow flex flex-col">
                    <span class="flex items-center gap-2 text-sm">
                        <i class="fas fa-microchip text-teal-400 text-sm"></i>
                        <span>${module.name}</span>
                    </span>
                    <p class="text-[10px] text-gray-300">${module.desc}</p>
                </div>
                <label class="switch">
                    <input type="checkbox" id="switch-${module.name.replace(/[^a-zA-Z0-9]/g, '')}" ${isActive ? 'checked' : ''} ${module.name === "STOP MODULE" ? 'disabled' : ''}>
                    <span class="slider"></span>
                </label>
            `;
            const switchElement = moduleItem.querySelector(`#switch-${module.name.replace(/[^a-zA-Z0-9]/g, '')}`);
            if (switchElement) {
                switchElement.addEventListener("change", async (e) => {
                    if (e.target.checked) {
                        const shizukuRunning = await checkShizukuStatus();
                        if (!shizukuRunning) {
                            showNotification("Shizuku is not running. Please start Shizuku and try again.");
                            e.target.checked = false;
                            return;
                        }
                        await handleModuleAction(module.name, module.url);
                    } else {
                        if (await showConfirmation(`Are you sure you want to disable ${module.name}?`)) {
                            activeModules.delete(module.name);
                            localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                            renderModules(allModules);
                        } else {
                            e.target.checked = true;
                        }
                    }
                });
            }
        }
        moduleList.appendChild(moduleItem);
    });
    if (stopModule && stopModule.name === "STOP MODULE") {
        const removeModulesBtn = document.getElementById("btn-remove-modules");
        if (removeModulesBtn) {
            removeModulesBtn.addEventListener("click", async () => {
                const shizukuRunning = await checkShizukuStatus();
                if (!shizukuRunning) {
                    showNotification("Shizuku is not running. Please start Shizuku and try again.");
                    return;
                }
                await handleModuleAction("STOP MODULE", stopModule.url);
                // Disable all switches in the performance tab
                const switches = document.querySelectorAll('#module-items .switch input');
                switches.forEach(switchElement => {
                    switchElement.checked = false;
                    switchElement.disabled = true;
                });
                // Clear active modules
                activeModules.clear();
                localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                showNotification("All performance modules have been disabled.");
            });
        }
    }
}

function renderFpsModules(modules) {
    const fpsModuleList = document.getElementById("fps-module-items");
    fpsModuleList.innerHTML = "";
    const stopModule = modules.find(module => module.name === "Stop Module");
    const otherModules = modules.filter(module => module.name !== "Stop Module");
    const sortedModules = stopModule ? [stopModule, ...otherModules] : otherModules;
    sortedModules.forEach((module, index) => {
        const isActive = activeModules.has(module.name);
        const isDownloaded = downloadedModules.has(module.name);
        const moduleItem = document.createElement("div");
        moduleItem.className = "bg-gray-800/50 border-l-4 border-purple-600 p-2 rounded-lg mb-1";
        if (index === 0 && module.name === "Stop Module") {
            moduleItem.innerHTML = `
                <button id="btn-remove-fps-modules" 
                        class="w-full px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400"
                        onclick="handleModuleAction('Stop Module', '${module.url}')">
                    Remove FPS Modules
                </button>
            `;
        } else {
            moduleItem.className += " flex justify-between items-center";
            moduleItem.innerHTML = `
                <div class="module-text-container flex-grow flex flex-col">
                    <span class="flex items-center gap-2 text-sm">
                        <i class="fas fa-tachometer-alt text-teal-400 text-sm"></i>
                        <span>${module.name}</span>
                    </span>
                </div>
                <label class="switch">
                    <input type="checkbox" id="fps-switch-${module.name.replace(/[^a-zA-Z0-9]/g, '')}" ${isActive ? 'checked' : ''}>
                    <span class="slider"></span>
                </label>
            `;
            const switchElement = moduleItem.querySelector(`#fps-switch-${module.name.replace(/[^a-zA-Z0-9]/g, '')}`);
            if (switchElement) {
                switchElement.addEventListener("change", async (e) => {
                    if (e.target.checked) {
                        const shizukuRunning = await checkShizukuStatus();
                        if (!shizukuRunning) {
                            showNotification("Shizuku is not running. Please start Shizuku and try again.");
                            e.target.checked = false;
                            return;
                        }
                        await handleModuleAction(module.name, module.url);
                    } else {
                        if (await showConfirmation(`Are you sure you want to disable ${module.name}?`)) {
                            activeModules.delete(module.name);
                            localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                            renderFpsModules(allFpsModules);
                        } else {
                            e.target.checked = true;
                        }
                    }
                });
            }
        }
        fpsModuleList.appendChild(moduleItem);
    });
}

function renderFakeDevices(fakeDevices) {
    const fakeDeviceList = document.getElementById("fake-device-items");
    fakeDeviceList.innerHTML = "";
    fakeDevices.forEach(device => {
        if (device.name === "Restore Device") return;
        const isActive = activeFakeDevices.has(device.name);
        const isDownloaded = downloadedModules.has(device.name);
        const deviceItem = document.createElement("div");
        deviceItem.className = "bg-gray-800/50 border-l-4 border-purple-600 p-2-rounded-lg mb-1 flex justify-between items-center";
        deviceItem.innerHTML = `
            <div class="module-text-container flex-grow flex flex-col">
                <span class="flex items-center gap-2 text-sm">
                    <i class="fas fa-mobile-alt text-teal-400 text-sm"></i>
                    <span>${device.name}</span>
                </span>
            </div>
            <label class="switch">
                <input type="checkbox" id="fake-device-${device.name.replace(/[^a-zA-Z0-9]/g, '')}" ${isActive ? 'checked' : ''}>
                <span class="slider"></span>
            </label>
        `;
        fakeDeviceList.appendChild(deviceItem);
        const checkboxElement = document.getElementById(`fake-device-${device.name.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) {
            checkboxElement.addEventListener("change", async (e) => {
                if (e.target.checked) {
                    if (activeFakeDevices.size > 0) {
                        showNotification("Only one fake device can be active at a time. Please disable the active fake device first.");
                        e.target.checked = false;
                        return;
                    }
                    const shizukuRunning = await checkShizukuStatus();
                    if (!shizukuRunning) {
                        showNotification("Shizuku is not running. Please start Shizuku and try again.");
                        e.target.checked = false;
                        return;
                    }
                    await handleFakeDeviceAction(device.name, device.url);
                } else {
                    if (await showConfirmation(`Are you sure you want to disable ${device.name}?`)) {
                        activeFakeDevices.delete(device.name);
                        localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
                        renderFakeDevices(allFakeDevices);
                        loadDeviceInfo();
                    } else {
                        e.target.checked = true;
                    }
                }
            });
        }
    });
}

function renderGames(games) {
    const gameList = document.getElementById("game-items");
    gameList.innerHTML = "";
    games.forEach(game => {
        const isSelected = selectedGames.has(game.game);
        const gameItem = document.createElement("div");
        gameItem.className = "bg-gray-800/50 border-l-4 border-purple-600 p-2 rounded-lg mb-1 flex justify-between items-center";
        gameItem.innerHTML = `
            <div class="module-text-container flex-grow flex flex-col">
                <span class="flex items-center gap-2 text-sm">
                    <i class="fas fa-gamepad text-teal-400 text-sm"></i>
                    <span>${game.game}</span>
                </span>
            </div>
            <label class="switch">
                <input type="checkbox" id="game-${game.game.replace(/[^a-zA-Z0-9]/g, '')}" ${isSelected ? 'checked' : ''}>
                <span class="slider"></span>
            </label>
        `;
        gameList.appendChild(gameItem);
        const checkboxElement = document.getElementById(`game-${game.game.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) {
            checkboxElement.addEventListener("change", async (e) => {
                if (e.target.checked) {
                    selectedGames.add(game.game);
                    localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
                    const shizukuRunning = await checkShizukuStatus();
                    if (!shizukuRunning) {
                        showNotification("Shizuku is not running. Please start Shizuku and try again.");
                        e.target.checked = false;
                        selectedGames.delete(game.game);
                        localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
                        return;
                    }
                    await handleGameAction(game.game, game.command);
                } else {
                    if (await showConfirmation(`Are you sure you want to disable optimization for ${game.game}?`)) {
                        selectedGames.delete(game.game);
                        localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
                    } else {
                        e.target.checked = true;
                    }
                }
            });
        }
    });
}

async function handleModuleAction(moduleName, moduleUrl) {
    if (activeModules.has(moduleName) && moduleName !== "STOP MODULE" && moduleName !== "Stop Module") {
        showNotification(`${moduleName} is already active.`);
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (switchElement) switchElement.checked = true;
        if (fpsSwitchElement) fpsSwitchElement.checked = true;
        return;
    }
    if (!window.Android) {
        showNotification("This feature is only available in the Android application.");
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (switchElement) switchElement.checked = false;
        if (fpsSwitchElement) fpsSwitchElement.checked = false;
        return;
    }
    const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
    const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
    const logId = generateRandomId();
    window.currentLogId = logId;
    window.currentOutput = "";
    if (moduleName !== "STOP MODULE" && moduleName !== "Stop Module") {
        activeModules.add(moduleName);
        localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
    }
    if (!downloadedModules.has(moduleName)) {
        showDownloadModal(moduleName, moduleUrl);
    } else {
        try {
            let runCommand = `sh ${modulePath}`;
            if (selectedGames.size > 0 && moduleName !== "STOP MODULE" && moduleName !== "Stop Module") {
                for (const game of allGames) {
                    if (selectedGames.has(game.game)) {
                        const packageName = game.command.match(/\+([a-zA-Z0-9.]+)/)?.[1] || '';
                        if (packageName) {
                            runCommand += ` ${packageName}`;
                        }
                    }
                }
            }
            await window.Android.executeCommand(runCommand, moduleName, logId);
        } возрастающий
            console.error("Error executing module:", e);
            showNotification("Failed to run module. Ensure Shizuku is running and permissions are granted.");
            if (moduleName !== "STOP MODULE" && moduleName !== "Stop Module") {
                activeModules.delete(moduleName);
                localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
            }
            window.runComplete(moduleName, false, logId);
            const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
            const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
            if (switchElement) switchElement.checked = false;
            if (fpsSwitchElement) fpsSwitchElement.checked = false;
        }
    }
}

async function handleFakeDeviceAction(deviceName, deviceUrl) {
    if (activeFakeDevices.has(deviceName)) {
        showNotification(`${deviceName} is already active.`);
        const checkboxElement = document.getElementById(`fake-device-${deviceName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) checkboxElement.checked = true;
        return;
    }
    if (!window.Android) {
        showNotification("This feature is only available in the Android application.");
        const checkboxElement = document.getElementById(`fake-device-${deviceName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) checkboxElement.checked = false;
        return;
    }
    const fileName = deviceName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
    const devicePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
    const logId = generateRandomId();
    window.currentLogId = logId;
    window.currentOutput = "";
    activeFakeDevices.add(deviceName);
    localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
    if (!downloadedModules.has(deviceName)) {
        showDownloadModal(deviceName, deviceUrl);
    } else {
        try {
            const runCommand = `sh ${devicePath}`;
            await window.Android.executeCommand(runCommand, deviceName, logId);
        } catch (e) {
            console.error("Error executing fake device module:", e);
            showNotification("Failed to run fake device module. Ensure Shizuku is running and permissions are granted.");
            activeFakeDevices.delete(deviceName);
            localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
            window.runComplete(deviceName, false, logId);
            const checkboxElement = document.getElementById(`fake-device-${deviceName.replace(/[^a-zA-Z0-9]/g, '')}`);
            if (checkboxElement) checkboxElement.checked = false;
        }
    }
}

async function handleGameAction(gameName, gameCommand) {
    if (!window.Android) {
        showNotification("This feature is only available in the Android application.");
        const checkboxElement = document.getElementById(`game-${gameName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) checkboxElement.checked = false;
        return;
    }
    const shizukuRunning = await checkShizukuStatus();
    if (!shizukuRunning) {
        showNotification("Shizuku is not running. Please start Shizuku and try again.");
        const checkboxElement = document.getElementById(`game-${gameName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) checkboxElement.checked = false;
        return;
    }
    const logId = generateRandomId();
    window.currentLogId = logId;
    window.currentOutput = "";
    try {
        await window.Android.executeCommand(gameCommand, gameName, logId);
    } catch (e) {
        console.error("Error executing game command:", e);
        showNotification(`Failed to optimize ${gameName}. Ensure Shizuku is running and permissions are granted.`);
        selectedGames.delete(gameName);
        localStorage.setItem("selectedGames", JSON.stringify([...selectedGames]));
        window.runComplete(gameName, false, logId);
        const checkboxElement = document.getElementById(`game-${gameName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (checkboxElement) checkboxElement.checked = false;
    }
}

async function handleRestoreDevice() {
    if (!window.Android) {
        showNotification("This feature is only available in the Android application.");
        return;
    }
    const shizukuRunning = await checkShizukuStatus();
    if (!shizukuRunning) {
        showNotification("Shizuku is not running. Please start Shizuku and try again.");
        return;
    }
    const moduleName = "Restore Device";
    const fileName = "restoredevice.sh";
    const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
    const logId = generateRandomId();
    window.currentLogId = logId;
    window.currentOutput = "";
    if (!downloadedModules.has(moduleName)) {
        showDownloadModal(moduleName, RESTORE_DEVICE_URL);
    } else {
        try {
            const runCommand = `sh ${modulePath}`;
            await window.Android.executeCommand(runCommand, moduleName, logId);
        } catch (e) {
            console.error("Error executing restore device module:", e);
            showNotification("Failed to run restore device module. Ensure Shizuku is running and permissions are granted.");
            window.runComplete(moduleName, false, logId);
        }
    }
}

async function handleCustomModule() {
    const fileInput = document.getElementById("custom-module-input");
    const file = fileInput.files[0];
    const button = document.getElementById("custom-module-btn");
    if (!file) {
        showNotification("Please select a file to run.");
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        return;
    }
    const fileExtension = file.name.split('.').pop().toLowerCase();
    if (fileExtension !== 'sh') {
        showNotification("The selected file is not a .sh script. Please select a .sh file.");
        fileInput.value = '';
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        return;
    }
    if (!window.Android) {
        showNotification("This feature is only available in the Android application.");
        fileInput.value = '';
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        return;
    }
    const shizukuRunning = await checkShizukuStatus();
    if (!shizukuRunning) {
        showNotification("Shizuku is not running. Please start Shizuku and try again.");
        fileInput.value = '';
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        return;
    }
    const moduleName = file.name.replace(/\.sh$/, '');
    if (activeModules.has(moduleName)) {
        showNotification("This module is already active.");
        fileInput.value = '';
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        return;
    }
    const logId = generateRandomId();
    window.currentLogId = logId;
    window.currentOutput = "";
    activeModules.add(moduleName);
    localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
    try {
        const reader = new FileReader();
        reader.onload = async function(e) {
            const fileContent = e.target.result;
            const fileName = moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
            const filePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
            if (window.Android?.saveCustomModule) {
                await window.Android.saveCustomModule(fileContent, filePath);
                let runCommand = `sh ${filePath}`;
                if (selectedGames.size > 0) {
                    for (const game of allGames) {
                        if (selectedGames.has(game.game)) {
                            const packageName = game.command.match(/\+([a-zA-Z0-9.]+)/)?.[1] || '';
                            if (packageName) {
                                runCommand += ` ${packageName}`;
                            }
                        }
                    }
                }
                try {
                    await window.Android.executeCommand(runCommand, moduleName, logId);
                } catch (e) {
                    console.error("Error executing custom module:", e);
                    showNotification("Failed to run custom module. Ensure Shizuku is running and permissions are granted.");
                    activeModules.delete(moduleName);
                    localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                    window.runComplete(moduleName, false, logId);
                    fileInput.value = '';
                    button.textContent = "Select";
                    button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
                }
            } else {
                showNotification("Android file save functionality not available.");
                activeModules.delete(moduleName);
                localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                window.runComplete(moduleName, false, logId);
                fileInput.value = '';
                button.textContent = "Select";
                button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
            }
        };
        reader.readAsText(file);
    } catch (e) {
        console.error("Error processing custom module:", e);
        showNotification("Failed to process custom module.");
        activeModules.delete(moduleName);
        localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
        window.runComplete(moduleName, false, logId);
        fileInput.value = '';
        button.textContent = "Select";
        button.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
    }
}

function showDownloadModal(moduleName, moduleUrl) {
    const modal = document.getElementById("download-modal");
    const progressBar = document.getElementById("modal-progress");
    const statusText = document.getElementById("modal-status");
    const title = document.getElementById("modal-title");
    title.innerHTML = `<i class="fas fa-download mr-2"></i>Downloading ${moduleName}`;
    statusText.textContent = "Starting download...";
    progressBar.style.width = "0%";
    modal.style.display = "flex";
    let currentProgress = 0;
    const progressInterval = setInterval(() => {
        currentProgress = Math.min(currentProgress + 5, 90);
        progressBar.style.width = `${currentProgress}%`;
        statusText.textContent = `Progress: ${currentProgress}%`;
    }, 300);
    window.downloadingModuleInterval = progressInterval;
    try {
        if (window.Android?.downloadFile) {
            window.Android.downloadFile(moduleUrl, moduleName);
        } else {
            showNotification("Download functionality not available in this environment.");
            modal.style.display = "none";
            clearInterval(window.downloadingModuleInterval);
            window.runComplete(moduleName, false, window.currentLogId);
            const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
            const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
            const checkboxElement = document.getElementById(`fake-device-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
            if (switchElement) switchElement.checked = false;
            if (fpsSwitchElement) fpsSwitchElement.checked = false;
            if (checkboxElement) checkboxElement.checked = false;
        }
    } catch (e) {
        console.error("Error initiating download:", e);
        showNotification("Failed to start download. Check your internet connection or Android interface.");
        modal.style.display = "none";
        clearInterval(window.downloadingModuleInterval);
        window.runComplete(moduleName, false, window.currentLogId);
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const checkboxElement = document.getElementById(`fake-device-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (switchElement) switchElement.checked = false;
        if (fpsSwitchElement) fpsSwitchElement.checked = false;
        if (checkboxElement) checkboxElement.checked = false;
    }
}

window.onShellOutput = function(moduleName, output, logId) {
    const cmdOutputModal = document.getElementById("cmd-output-modal");
    const cmdOutput = document.getElementById("cmd-output");
    window.currentOutput = (window.currentOutput || "") + output + "\n";
    cmdOutput.innerHTML = parseAnsiColors(window.currentOutput);
    cmdOutput.scrollTop = cmdOutput.scrollHeight;
    cmdOutputModal.style.display = "flex";
    if (window.Android?.saveLog) {
        window.Android.saveLog(window.currentOutput, logId);
    }
};

window.downloadComplete = function(moduleName, success) {
    const modal = document.getElementById("download-modal");
    const progressBar = document.getElementById("modal-progress");
    const statusText = document.getElementById("modal-status");
    clearInterval(window.downloadingModuleInterval);
    progressBar.style.width = success ? "100%" : "0%";
    statusText.textContent = success ? "Download complete!" : "Download failed.";
    setTimeout(() => { modal.style.display = "none"; }, 500);
    if (success) {
        downloadedModules.add(moduleName);
        localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules]));
        showNotification(`${moduleName} downloaded successfully!`);
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const checkboxElement = document.getElementById(`fake-device-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const isStopModule = moduleName === "STOP MODULE" || moduleName === "Stop Module";
        if ((switchElement && switchElement.checked) || (fpsSwitchElement && fpsSwitchElement.checked) || (checkboxElement && checkboxElement.checked) || isStopModule) {
            const fileName = moduleName === "Restore Device" ? "restoredevice.sh" : moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
            const modulePath = `/storage/emulated/0/Download/com.fps.injector/${fileName}`;
            let runCommand = `sh ${modulePath}`;
            if (selectedGames.size > 0 && !isStopModule && moduleName !== "Restore Device") {
                for (const game of allGames) {
                    if (selectedGames.has(game.game)) {
                        const packageName = game.command.match(/\+([a-zA-Z0-9.]+)/)?.[1] || '';
                        if (packageName) {
                            runCommand += ` ${packageName}`;
                        }
                    }
                }
            }
            const logId = window.currentLogId || generateRandomId();
            try {
                window.Android.executeCommand(runCommand, moduleName, logId);
            } catch (e) {
                console.error("Error executing module after download:", e);
                showNotification("Failed to run module. Ensure Shizuku is running and permissions are granted.");
                activeModules.delete(moduleName);
                activeFakeDevices.delete(moduleName);
                localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
                localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
                window.runComplete(moduleName, false, logId);
                if (switchElement) switchElement.checked = false;
                if (fpsSwitchElement) fpsSwitchElement.checked = false;
                if (checkboxElement) checkboxElement.checked = false;
            }
        }
    } else {
        showNotification(`Download failed for ${moduleName}. Check your internet connection.`);
        activeModules.delete(moduleName);
        activeFakeDevices.delete(moduleName);
        localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
        localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
        window.runComplete(moduleName, false, window.currentLogId);
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const checkboxElement = document.getElementById(`fake-device-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (switchElement) switchElement.checked = false;
        if (fpsSwitchElement) fpsSwitchElement.checked = false;
        if (checkboxElement) checkboxElement.checked = false;
    }
};

window.runComplete = function(moduleName, success, logId) {
    const finalLogId = logId || window.currentLogId;
    const timestamp = new Date().toLocaleString();
    const fileName = moduleName === "Restore Device" ? "restoredevice.sh" : moduleName.replace(/[^a-zA-Z0-9]/g, '') + ".sh";
    const command = selectedGames.size > 0 && !moduleName.includes("STOP MODULE") && !moduleName.includes("Stop Module") && moduleName !== "Restore Device"
        ? `sh /storage/emulated/0/Download/com.fps.injector/${fileName} ${[...selectedGames].map(game => allGames.find(g => g.game === game)?.command.match(/\+([a-zA-Z0-9.]+)/)?.[1] || '').join(' ')}`
        : `sh /storage/emulated/0/Download/com.fps.injector/${fileName}`;
    commandLogs.push({
        command: command.trim(),
        output: window.currentOutput,
        timestamp,
        logId: finalLogId
    });
    localStorage.setItem("commandLogs", JSON.stringify(commandLogs));
    renderLogs();
    if (success) {
        showNotification(`${moduleName} executed successfully!`);
        // Check if URL can be opened
        const lastOpened = sessionStorage.getItem('lastUrlOpenTime');
        const currentTime = Date.now();
        const oneMinute = 30 * 1000; // 1 minute in milliseconds
        if (!lastOpened || (currentTime - parseInt(lastOpened)) > oneMinute) {
            window.open('https://obqj2.com/4/9587058', '_blank');
            sessionStorage.setItem('lastUrlOpenTime', currentTime.toString());
        }
        if (window.Android?.deleteModuleFile && moduleName !== "STOP MODULE" && moduleName !== "Stop Module" && moduleName !== "Restore Device") {
            window.Android.deleteModuleFile(fileName);
            downloadedModules.delete(moduleName);
            localStorage.setItem("downloadedModules", JSON.stringify([...downloadedModules]));
        }
        if (allFakeDevices.some(device => device.name === moduleName) || moduleName === "Restore Device") {
            loadDeviceInfo();
        }
    } else {
        showNotification(`Failed to run module ${moduleName}. Check the logs for details.`);
        activeModules.delete(moduleName);
        activeFakeDevices.delete(moduleName);
        localStorage.setItem("activeModules", JSON.stringify([...activeModules]));
        localStorage.setItem("activeFakeDevices", JSON.stringify([...activeFakeDevices]));
        const switchElement = document.getElementById(`switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const fpsSwitchElement = document.getElementById(`fps-switch-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        const checkboxElement = document.getElementById(`fake-device-${moduleName.replace(/[^a-zA-Z0-9]/g, '')}`);
        if (switchElement) switchElement.checked = false;
        if (fpsSwitchElement) fpsSwitchElement.checked = false;
        if (checkboxElement) checkboxElement.checked = false;
    }
    loadModules();
    loadFpsModules();
    loadFakeDevices();
    window.currentOutput = "";
    window.currentLogId = null;
    if (moduleName.includes("Custom Module")) {
        document.getElementById("custom-module-input").value = '';
        document.getElementById("custom-module-btn").textContent = "Select";
        document.getElementById("custom-module-btn").className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
    }
};

function renderLogs() {
    const logPanels = document.querySelectorAll("#log-list");
    logPanels.forEach(logPanel => {
        logPanel.innerHTML = commandLogs.length === 0 ? `<p class="text-gray-300 text-sm"><i class="fas fa-info-circle mr-2"></i>No logs yet.</p>` : "";
        [...commandLogs].reverse().forEach((log, index) => {
            const originalIndex = commandLogs.length - 1 - index;
            const logItem = document.createElement("div");
            logItem.className = "flex justify-between items-center bg-gray-800/50 border-l-4 border-purple-600 p-2 rounded-lg mb-1";
            logItem.innerHTML = `
                <div class="flex flex-col">
                    <span class="text-teal-400 text-sm"><i class="fas fa-clock mr-2"></i>${log.timestamp}</span>
                    <p class="text-sm"><i class="fas fa-terminal mr-2"></i><strong>Command:</strong> ${log.command.length > 30 ? log.command.substring(0, 27) + '...' : log.command}</p>
                    <p class="text-sm"><i class="fas fa-id-badge mr-2"></i><strong>Log ID:</strong> ${log.logId || 'N/A'}</p>
                </div>
                <div class="flex gap-2">
                    <button class="text-teal-400 hover:text-teal-300" onclick="viewLog(${originalIndex})"><i class="fas fa-eye"></i></button>
                    <button class="text-red-400 hover:text-red-300" onclick="deleteLog(${originalIndex})"><i class="fas fa-trash"></i></button>
                </div>
            `;
            logPanel.appendChild(logItem);
        });
    });
}

async function clearAllLogs() {
    if (await showConfirmation("Are you sure you want to clear all logs?")) {
        if (window.Android?.deleteLog) {
            for (const log of commandLogs) {
                window.Android.deleteLog(log.logId);
            }
        }
        commandLogs = [];
        localStorage.setItem("commandLogs", JSON.stringify(commandLogs));
        renderLogs();
        showNotification("All logs cleared successfully!");
    }
}

function viewLog(index) {
    const log = commandLogs[index];
    const modal = document.getElementById("download-modal");
    const modalContent = document.querySelector("#download-modal .modal-content");
    modalContent.innerHTML = `
        <h2 class="text-base font-bold text-teal-300 mb-2"><i class="fas fa-file-alt mr-2"></i>Log Details</h2>
        <p class="text-xs"><i class="fas fa-clock mr-2"></i><strong>Timestamp:</strong> ${log.timestamp}</p>
        <p class="text-xs"><i class="fas fa-terminal mr-2"></i><strong>Command:</strong> ${log.command}</p>
        <p class="text-xs"><i class="fas fa-id-badge mr-2"></i><strong>Log ID:</strong> ${log.logId || 'N/A'}</p>
        <pre class="cmd-output" style="max-height: 30vh; overflow-y: auto; word-wrap: break-word; overflow: hidden; text-overflow: ellipsis;">${parseAnsiColors(log.output)}</pre>
        <button class="px-3 py-1 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400 mt-2 w-full" onclick="document.getElementById('download-modal').style.display='none'">Close</button>
    `;
    modal.style.display = "flex";
}

async function deleteLog(index) {
    if (await showConfirmation("Are you sure you want to delete this log?")) {
        const log = commandLogs[index];
        if (window.Android?.deleteLog) window.Android.deleteLog(log.logId);
        commandLogs.splice(index, 1);
        localStorage.setItem("commandLogs", JSON.stringify(commandLogs));
        renderLogs();
        showNotification("Log deleted successfully!");
    }
}

function showTab(tabId) {
    const allContents = document.querySelectorAll('.tab-content');
    const allNavItems = document.querySelectorAll('.nav-item');
    
    // Set all tabs to fade out
    allContents.forEach(content => {
        content.style.opacity = '0';
    });

    // Update active nav item
    allNavItems.forEach(item => {
        item.classList.remove('active');
    });
    document.querySelector(`.nav-item[data-tab="${tabId}"]`).classList.add('active');

    // Show the selected tab with fade-in
    const targetContent = document.getElementById(tabId);
    targetContent.style.display = 'block';
    setTimeout(() => {
        targetContent.classList.add('active');
        targetContent.style.opacity = '1';
    }, 10); // Small delay to ensure display: block is applied before opacity transition

    // Hide other tabs after transition
    setTimeout(() => {
        allContents.forEach(content => {
            if (content.id !== tabId) {
                content.style.display = 'none';
            }
        });
    }, 300); // Match duration-300
}

// Sidebar toggle functionality
document.getElementById("sidebar-toggle").addEventListener("click", () => {
    const sidebar = document.getElementById("sidebar");
    sidebar.classList.toggle("open");
});

document.getElementById("sidebar-close").addEventListener("click", () => {
    const sidebar = document.getElementById("sidebar");
    sidebar.classList.remove("open");
});

document.getElementById("device-info-toggle").addEventListener("click", () => {
    const content = document.getElementById("device-info");
    content.classList.toggle("show");
    const icon = document.getElementById("device-info-toggle").querySelector(".fa-chevron-down, .fa-chevron-up");
    icon.classList.toggle("fa-chevron-down");
    icon.classList.toggle("fa-chevron-up");
});

document.getElementById("refresh-device-info").addEventListener("click", () => {
    loadDeviceInfo();
    showNotification("Device info refreshed!");
});

const customModuleInput = document.getElementById("custom-module-input");
const customModuleBtn = document.getElementById("custom-module-btn");

customModuleBtn.addEventListener("click", async () => {
    if (customModuleBtn.textContent === "Select") {
        customModuleInput.click();
    } else {
        const shizukuRunning = await checkShizukuStatus();
        if (!shizukuRunning) {
            showNotification("Shizuku is not running. Please start Shizuku and try again.");
            customModuleInput.value = '';
            customModuleBtn.textContent = "Select";
            customModuleBtn.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
            return;
        }
        handleCustomModule();
    }
});

customModuleInput.addEventListener("change", () => {
    if (customModuleInput.files.length) {
        const fileName = customModuleInput.files[0].name;
        const fileExtension = fileName.split('.').pop().toLowerCase();
        if (fileExtension === 'sh') {
            customModuleBtn.textContent = "Run";
            customModuleBtn.className = "px-4 py-2 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-500";
        } else {
            showNotification("The selected file is not a .sh script. Please select a .sh file.");
            customModuleInput.value = '';
            customModuleBtn.textContent = "Select";
            customModuleBtn.className = "px-4 py-2 bg-teal-500 text-gray-900 rounded-lg font-semibold hover:bg-teal-400";
        }
    }
});

document.getElementById("restore-device-btn").addEventListener("click", async () => {
    if (await showConfirmation("Are you sure you want to restore the device to its original settings?")) {
        handleRestoreDevice();
    }
});

document.querySelectorAll("#clear-logs-btn, #clear-logs-btn-performance, #clear-logs-btn-game").forEach(btn => {
    btn.addEventListener("click", clearAllLogs);
});

document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', () => {
        const tabId = item.getAttribute('data-tab');
        showTab(tabId);
        // Close sidebar when a tab is selected
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.remove("open");
    });
});

checkShizukuStatus();
loadModules();
loadFpsModules();
loadFakeDevices();
loadGames();
loadDeviceInfo();
loadAppVersion();
renderLogs();
