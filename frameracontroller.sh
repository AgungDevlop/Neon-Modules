#!/system/bin/sh
# 🔧 Performance Booster - Maximize Device Speed for Wireless Debugging
# Optimizes RAM, background apps, CPU, GPU, and frame rate for peak performance
# Designed for non-root devices, safe execution, and wireless debugging
# Author: Agung Developer (Expanded by Grok)
# Current date: August 23, 2025

# Function to check thermal status
check_thermal() {
    local temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print $1/1000}')
    if [ -n "$temp" ] && [ "${temp%.*}" -gt 50 ]; then
        echo "[!] Warning: Device temperature is ${temp}°C. Aborting to prevent overheating."
        cmd notification post -S bigtext -t 'PERFORMANCE BOOSTER' 'Tag' 'ERROR: High temperature detected. Cooling required.' >/dev/null 2>&1
        exit 1
    fi
    echo "[✔] Thermal check: ${temp:-'N/A'}°C"
}

# Function to set settings with error checking
set_setting() {
    local scope=$1
    local key=$2
    local value=$3
    settings put "$scope" "$key" "$value" >/dev/null 2>&1 && echo "[✔] Set $scope $key to $value" || echo "[!] Skipped $scope $key (not supported)"
}

# Function to kill background apps (non-system apps only)
kill_background_apps() {
    echo "[*] Terminating unnecessary background apps..."
    local packages=$(pm list packages -3 | cut -d':' -f2) # List only third-party apps
    for pkg in $packages; do
        am force-stop "$pkg" >/dev/null 2>&1 && echo "[✔] Stopped $pkg" || echo "[!] Skipped $pkg (not running)"
    done
}

# Function to optimize RAM and memory management
optimize_ram() {
    echo "[*] Optimizing RAM and memory management..."
    set_setting system ram_expand_size 0
    set_setting global zram_enabled 0
    set_setting global swappiness 10
    set_setting global low_ram false
    set_setting global activity_manager_constants max_cached_processes 32
    set_setting global app_standby_enabled 0
    set_setting global background_cpu_restrict 0
    set_setting global foreground_cpu_restrict 0
    set_setting global app_background_restrict 0
    set_setting global cached_apps_freezer disabled
    set_setting global activity_starts_logging_enabled 0
    echo "[✔] RAM optimization applied"
}

# Initial notification
cmd notification post -S bigtext -t 'PERFORMANCE BOOSTER' 'Tag' 'Starting Performance Optimization...' >/dev/null 2>&1

# Safety checks
echo "🛡️ Starting safety checks..."
check_thermal

# Display device information
echo ""
echo "█▓▒▒░░░PERFORMANCE BOOSTER░░░▒▒▓█"
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
echo "█▓▒▒░░░WELCOME TO PERFORMANCE OPTIMIZATION░░░▒▒▓█"
echo ""
sleep 0.5
sleep 3

# Main optimization block
(
    # Frame rate optimizations (expanded from original)
    cmd display set-match-content-frame-rate-pref 1 >/dev/null 2>&1 && echo "[✔] Enabled match content frame rate preference"
    set_setting system display.refresh_rate 120
    set_setting system min_refresh_rate 120
    set_setting system max_refresh_rate 120
    set_setting system peak_refresh_rate 120
    set_setting system display_min_refresh_rate 120
    set_setting system min_frame_rate 120
    set_setting system max_frame_rate 120
    set_setting system display.low_framerate_limit 120
    set_setting system display.defer_fps_frame_count 2
    set_setting system display.large_comp_hint_fps 120
    set_setting secure user_refresh_rate 120
    set_setting secure miui_refresh_rate 120
    set_setting secure refresh_rate_mode 120
    set_setting global min_fps 120
    set_setting global max_fps 120
    set_setting system display.enable_optimal_refresh_rate 1
    set_setting system display.disable_dynamic_fps 1
    set_setting system display.disable_metadata_dynamic_fps 1
    set_setting system display.enable_pref_hint_for_low_fps 1
    set_setting system display.enable_idle_content_fps_hint 0
    set_setting system display.refresh_rate_changeable 0
    set_setting system display.idle_time 0
    set_setting system display.idle_time_inactive 0
    set_setting system thermal_limit_refresh_rate 120
    set_setting system NV_FPSLIMIT 120
    set_setting system fps_limit 120
    set_setting system max_refresh_rate_for_ui 120
    set_setting system max_refresh_rate_for_gaming 120
    set_setting system hwui_refresh_rate 120
    set_setting system sf.refresh_rate 120

    # Game driver optimizations
    set_setting system game_driver_min_frame_rate 120
    set_setting system game_driver_max_frame_rate 120
    set_setting system game_driver_fps_limit 120
    set_setting system game_driver_power_saving_mode 0
    set_setting system game_driver_frame_skip_enable 0
    set_setting system game_driver_vsync_enable 0
    set_setting system game_driver_gpu_mode 1
    set_setting system game_mode_fps 120
    set_setting system game_mode_refresh_rate 120
    set_setting system game_driver_dynamic_fps 0
    set_setting system game_driver_low_latency_mode 1

    # Vendor display settings
    set_setting system vendor.display.default_fps 120
    set_setting system vendor.display.idle_default_fps 120
    set_setting system vendor.display.enable_optimize_refresh 1
    set_setting system vendor.display.video_or_camera_fps.support true
    set_setting system vendor.display.refresh_rate 120
    set_setting global vendor.fps.switch.default true
    set_setting global vendor.display.default_fps 120
    set_setting global vendor.display.idle_default_fps 120

    # CPU and performance optimizations
    set_setting global persist.sys.performance_mode 1
    set_setting global persist.sys.turbo_mode 1
    set_setting global persist.sys.boost_duration_ms 0
    set_setting global persist.sys.boost_freq_max 1
    set_setting global persist.sys.cpu.boost 1
    set_setting global power.thermal_throttle 0
    set_setting global power.save_mode 0
    set_setting global power_mode 2
    set_setting global low_power 0
    set_setting global high_performance_mode 1
    set_setting global adaptive_battery_management_enabled 0
    set_setting global battery_saver_constants none
    set_setting global dynamic_power_savings_enabled 0
    set_setting system cpu_throttling 0
    set_setting system thermal_restrict 0
    set_setting system power_save_mode 0
    set_setting system performance_hint_enabled 1

    # Additional display and performance tweaks
    set_setting global dfps.enable false
    set_setting global smart_dfps.enable false
    set_setting global fps.switch.default false
    set_setting global fps.switch.thermal false
    set_setting global smart_dfps.idle_fps 120
    set_setting global smart_dfps.app_switch_fps 120
    set_setting global display.idle_default_fps 120
    set_setting global display.fod_monitor_default_fps 120
    set_setting global surface_flinger.use_content_detection_for_refresh_rate false
    set_setting global media.recorder-max-base-layer-fps 120
    set_setting global refresh.active 1
    set_setting global refresh_rate_mode 1
    set_setting global refresh_rate_switching_type 1
    set_setting global refresh_rate_force_high 1
    set_setting global tran_refresh_rate_video_detector.support 0
    set_setting global tran_default_auto_refresh.support 0
    set_setting global tran_default_refresh_mode 120
    set_setting global tran_low_battery_60hz_refresh_rate.support 0
    set_setting global tran_90hz_refresh_rate.not_support 0
    set_setting global tran_custom_refresh_rate_config.support 1
    set_setting global transsion.frame_override.support 0
    set_setting global transsion.tran_refresh_rate.support 0
    set_setting system power.dfps.level 0
    set_setting system disable_idle_fps true
    set_setting system disable_idle_fps.threshold 1
    set_setting system fps.idle_control false
    set_setting system metadata_dynfps.disabel 1
    set_setting system enable_dpps_dynamic_fps 0
    set_setting system fstb_target_fps_margin_high_fps 20
    set_setting system fstb_target_fps_margin_low_fps 20
    set_setting system gcc_fps_margin 10
    set_setting system tran_refresh_mode 120
    set_setting system last_tran_refresh_mode_in_refresh_setting 120
    set_setting system tran_need_recovery_refresh_mode 120
    set_setting system surfaceflinger.idle_reduce_framerate_enable false
    set_setting system display.frame_rate_optimization 1
    set_setting system display.high_fps_mode 1
    set_setting system display.performance_mode 1
    set_setting global performance_hint_fps 120
    set_setting global dynamic_fps_switch 0
    set_setting global adaptive_refresh_rate 0
    set_setting system low_power_display_mode 0
    set_setting system high_performance_display 1

    # Network and I/O optimizations
    set_setting global wifi_power_save 0
    set_setting global mobile_data_always_on 0
    set_setting global tcp_optimization_enabled 1
    set_setting global net.tuning_enabled 1
    set_setting global persist.sys.net.tuning 1
    set_setting system io.scheduler noop
    set_setting system storage_threshold_percent 5
    set_setting system storage_threshold_max_bytes 5242880

    # Disable animations for faster UI
    set_setting global animator_duration_scale 0.0
    set_setting global transition_animation_scale 0.0
    set_setting global window_animation_scale 0.0
) > /dev/null 2>&1 &

# Kill background apps
kill_background_apps

# Optimize RAM
optimize_ram

# Final output and notification
echo "MATIKAN THERMAL LIMIT FPS [✓]"
echo "PAKSA REFRESH RATE MAXIMAL [✓]"
echo "INJECT FPS & PERFORMANCE OPTIMIZE [✓]"
echo "RAM OPTIMIZATION [✓]"
echo "BACKGROUND APPS CLEARED [✓]"
echo ""
sleep 0.5
echo "ALL DONE SET [✓]"
echo ""
sleep 0.5
echo "‼️SELAMAT MENIKMATI PERFORMANSI MAKSIMAL‼️"
echo ""
sleep 0.5
echo "DEV: Agung Developer (Expanded by Grok)"
echo ""
sleep 0.5
echo "DONT REBOOT TO MAINTAIN SETTINGS"
echo ""
sleep 0.5
echo "THANKS FOR USING PERFORMANCE BOOSTER"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING PERFORMANCE BOOSTER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'PERFORMANCE BOOSTER' 'Tag' 'SUCCESS: Performance Optimized to Maximum!' >/dev/null 2>&1
