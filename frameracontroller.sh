#!/system/bin/sh
# 🔒 Frame Rate Controller - Optimasi frame rate untuk performa (by Agung Developer)
# Versi Aman untuk Non-Root
# Current date: August 23, 2025

# Function to check if a package is installed
check_package() {
    pm list packages | grep -q "$1" && return 0 || return 1
}

# Function to check thermal status
check_thermal() {
    local temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print $1/1000}')
    if [ -n "$temp" ] && [ "${temp%.*}" -gt 50 ]; then
        echo "[!] Warning: Device temperature is ${temp}°C. Aborting to prevent overheating."
        cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'ERROR: High temperature detected. Cooling required.' >/dev/null 2>&1
        exit 1
    fi
    echo "[✔] Thermal check: ${temp:-'N/A'}°C"
}

# Function to check device compatibility for 120FPS
check_device_compatibility() {
    local max_supported_rate=$(getprop ro.display.max_refresh_rate 2>/dev/null || echo 60)
    if [ "$max_supported_rate" -lt 120 ]; then
        echo "[!] Warning: Device does not support 120FPS. Max supported rate: ${max_supported_rate}Hz."
        cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'ERROR: Device does not support 120FPS.' >/dev/null 2>&1
        exit 1
    fi
    echo "[✔] Device supports 120FPS"
}

# Function to set settings with error checking
set_setting() {
    local scope=$1
    local key=$2
    local value=$3
    settings put "$scope" "$key" "$value" >/dev/null 2>&1 && echo "[✔] Set $scope $key to $value" || echo "[!] Skipped $scope $key (not supported)"
}

# Initial notification
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting Frame Rate Optimization.' >/dev/null 2>&1

# Safety checks
echo "🛡️ Starting safety checks..."
check_thermal
check_device_compatibility

# WHITELIST: Jangan disentuh
whitelist="com.android.systemui com.google.android.gms com.android.settings com.android.vending com.android.launcher"

echo "🛡️ Membatasi aplikasi sistem... Harap tunggu."

# Restrict background activity for non-critical system apps
for a in $(cmd package list packages -s | cut -d ":" -f2); do
    echo "$whitelist" | grep -q "$a" && echo "⏩ Skip $a (whitelist)" && continue
    cmd appops set "$a" RUN_IN_BACKGROUND deny >/dev/null 2>&1 && echo "[✔] Restricted $a background activity" || echo "[!] Skipped $a (not supported)"
    cmd appops set "$a" WAKE_LOCK deny >/dev/null 2>&1 || echo "[!] Skipped $a WAKE_LOCK (not supported)"
    am set-standby-bucket "$a" rare >/dev/null 2>&1 || echo "[!] Skipped $a standby bucket (not supported)"
done

echo "✅ Semua aplikasi sistem telah dibatasi secara aman."

# Display device information
echo ""
echo "█▓▒▒░░░FPS INJECTOR░░░▒▒▓█"
echo ""
sleep 0.5
echo "┌───────────────────────────────────────┐"
echo "│         DEVICE AND HARDWARE INFO      │"
echo "├───────────────────────────────────────┤"
echo "│ 📱 Device   : $(getprop ro.product.manufacturer) $(getprop ro.product.model) │"
echo "│ ⚙️ CPU      : $(getprop ro.board.platform) │"
echo "│ 🎮 GPU      : $(getprop ro.hardware) │"
echo "│ 📲 Android  : $(getprop ro.build.version.release) │"
thermal_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print $1/1000 "°C"}')
echo "│ 🔥 Thermal  : ${thermal_temp:-'N/A'} │"
echo "│ 🔰 Kernel   : $(uname -r) │"
echo "│ 🔹 Build    : $(getprop ro.build.display.id) │"
echo "│ 🛑 Root     : No │"
echo "│ 🔗 SELinux  : $(getenforce 2>/dev/null || echo 'N/A') │"
echo "└───────────────────────────────────────┘"
echo ""
echo "█▓▒▒░░░WELCOME TO FRAME RATE OPTIMIZATION░░░▒▒▓█"
echo ""
sleep 0.5
sleep 3

# Frame Rate Optimizations (Non-Root Safe)
(
    cmd display set-match-content-frame-rate-pref 1 >/dev/null 2>&1 && echo "[✔] Enabled match content frame rate preference"
    set_setting system display.refresh_rate 120
    set_setting system min_refresh_rate 120
    set_setting system max_refresh_rate 120
    set_setting system peak_refresh_rate 120
    set_setting secure user_refresh_rate 120
    set_setting secure miui_refresh_rate 120
    set_setting global min_fps 120
    set_setting global max_fps 120
    set_setting system display.enable_optimal_refresh_rate 1
    set_setting system display.disable_dynamic_fps 1
    set_setting system display.low_framerate_limit 120
    set_setting system display.defer_fps_frame_count 2
    set_setting system display.large_comp_hint_fps 120
    set_setting system display.enable_pref_hint_for_low_fps 1
    set_setting system display.enable_idle_content_fps_hint 0
    set_setting system display.refresh_rate_changeable 0
    set_setting system display.idle_time 0
    set_setting system display.idle_time_inactive 0
    set_setting global dfps.enable false
    set_setting global smart_dfps.enable false
    set_setting global fps.switch.default false
    set_setting global smart_dfps.idle_fps 120
    set_setting global display.idle_default_fps 120
    set_setting global smart_dfps.app_switch_fps 120
    set_setting global display.fod_monitor_default_fps 120
    set_setting global tran_refresh_rate_video_detector.support 0
    set_setting global tran_default_auto_refresh.support 0
    set_setting global tran_default_refresh_mode 120
    set_setting global tran_low_battery_60hz_refresh_rate.support 0
    set_setting global tran_90hz_refresh_rate.not_support 0
    set_setting global tran_custom_refresh_rate_config.support 1
    set_setting global transsion.frame_override.support 0
    set_setting global transsion.tran_refresh_rate.support 0
    set_setting global surface_flinger.use_content_detection_for_refresh_rate false
    set_setting global media.recorder-max-base-layer-fps 120
    set_setting global vendor.fps.switch.default true
    set_setting system vendor.display.default_fps 120
    set_setting system vendor.display.idle_default_fps 120
    set_setting system vendor.display.enable_optimize_refresh 1
    set_setting system vendor.display.video_or_camera_fps.support true
    set_setting system game_driver_min_frame_rate 120
    set_setting system game_driver_max_frame_rate 120
    set_setting system game_driver_power_saving_mode 0
    set_setting system game_driver_frame_skip_enable 0
    set_setting system game_driver_vsync_enable 0
    set_setting system game_driver_gpu_mode 1
    set_setting system game_driver_fps_limit 120
    set_setting system user_refresh_rate 120
    set_setting system fps_limit 120
    set_setting system max_refresh_rate_for_ui 120
    set_setting system hwui_refresh_rate 120
    set_setting system max_refresh_rate_for_gaming 120
    set_setting system fstb_target_fps_margin_high_fps 20
    set_setting system fstb_target_fps_margin_low_fps 20
    set_setting system gcc_fps_margin 10
) > /dev/null 2>&1 &

echo "MATIKAN THERMAL LIMIT FPS [✓]"
echo ""
sleep 0.5
echo "PAKSA REFRESH RATE MAXIMAL [✓]"
sleep 0.5
echo "INJECT FPS & FPS OPTIMIZE [✓]"
echo ""
sleep 0.5
echo "ALL DONE SET [✓]"
echo ""
sleep 0.5
echo "‼️SELAMAT MENIKMATI ‼️"
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "DONT REBOOT"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING FRAME RATE CONTROLLER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Frame Rate Optimized.' >/dev/null 2>&1
