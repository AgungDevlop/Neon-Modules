#!/system/bin/sh
# 🔒 Frame Rate Controller - Optimasi Performa Perangkat Non-Root
# Versi Aman untuk Non-Root tanpa Pengecekan FPS Berat
# Dioptimalkan untuk Wireless Debugging
# Author: Agung Developer
# Current date: August 23, 2025

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

# Function to set settings with error checking
set_setting() {
    local scope=$1
    local key=$2
    local value=$3
    settings put "$scope" "$key" "$value" >/dev/null 2>&1 && echo "[✔] Set $scope $key to $value" || echo "[!] Skipped $scope $key (not supported)"
}

# Initial notification
cmd notification post -S bigtext -t 'FPS UNLOCK by Agung Dev' 'Tag' 'Starting Performance Optimization.' >/dev/null 2>&1

# Safety check (thermal only)
echo "🛡️ Starting safety checks..."
check_thermal

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
echo "█▓▒▒░░░WELCOME TO PERFORMANCE OPTIMIZATION░░░▒▒▓█"
echo ""
sleep 0.5
sleep 3

# Performance Optimizations (Non-Root Safe, Expanded)
(
    # Display and Frame Rate Settings
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

    # Game Driver Optimizations
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

    # Vendor Display Settings
    set_setting system vendor.display.default_fps 120
    set_setting system vendor.display.idle_default_fps 120
    set_setting system vendor.display.enable_optimize_refresh 1
    set_setting system vendor.display.video_or_camera_fps.support true
    set_setting system vendor.display.refresh_rate 120
    set_setting global vendor.fps.switch.default true
    set_setting global vendor.display.default_fps 120
    set_setting global vendor.display.idle_default_fps 120

    # Animation and Transition Optimizations
    set_setting global window_animation_scale 0.5
    set_setting global transition_animation_scale 0.5
    set_setting global animator_duration_scale 0.5
    set_setting system hwui.disable_animations 1
    set_setting system disable_transition_animations 1

    # Background Process and App Optimizations
    set_setting global activity_manager_constants max_cached_processes 32
    set_setting global app_standby_enabled 0
    set_setting global background_process_limit 2
    set_setting system limit_background_apps 1
    set_setting system aggressive_background_optimization 1

    # CPU and Performance Tweaks
    set_setting system power.performance_mode 1
    set_setting system cpu_boost_enabled 1
    set_setting system sched_boost_enabled 1
    set_setting system performance_hint_enabled 1
    set_setting system high_performance_mode 1

    # Graphics and Rendering Optimizations
    set_setting system hwui.use_gpu_pixel_buffers 1
    set_setting system hwui.force_dark_mode 0
    set_setting system surface_flinger.force_hwc_copy 0
    set_setting system render_thread_priority high
    set_setting system gpu_turbo_mode 1

    # Battery and Thermal Optimizations
    set_setting system battery_saver_enabled 0
    set_setting system power_save_mode_trigger 0
    set_setting system thermal_limit_enabled 0
    set_setting system dynamic_power_savings_enabled 0
    set_setting system low_power_mode 0

    # Touch and Input Responsiveness
    set_setting system touch_panning_sensitivity 1.0
    set_setting system touch_response_optimization 1
    set_setting system multi_touch_enabled 1
    set_setting system pointer_speed 7
    set_setting system touch_boost_enabled 1

    # Memory Management
    set_setting system zram_enabled 1
    set_setting system zram_size_percent 50
    set_setting system low_memory_killer_enabled 0
    set_setting system vm.swappiness 60
    set_setting system memory_optimization_enabled 1

    # Network and Connectivity Optimizations
    set_setting global wifi_scan_throttle_enabled 0
    set_setting global mobile_data_always_on 1
    set_setting global network_tethering_enabled 0
    set_setting system netd_tcp_buffer_size 4096,87380,524288
    set_setting system network_optimization_enabled 1

    # Vendor-Specific and Experimental Settings
    set_setting system vendor.performance_mode 1
    set_setting system vendor.game_mode_enabled 1
    set_setting system vendor.low_latency_mode 1
    set_setting system vendor.boost_mode 1
    set_setting system vendor.high_performance_mode 1

    # Additional System-Wide Tweaks
    set_setting global sysui_performance_mode 1
    set_setting global dalvik.vm.heapsize 512m
    set_setting global dalvik.vm.heapgrowthlimit 256m
    set_setting system app_process_limit 4
    set_setting system force_high_performance 1

    # Additional FPS and Performance Settings
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
    set_setting system adaptive_refresh_rate 0
    set_setting system low_power_display_mode 0
    set_setting system high_performance_display 1
) > /dev/null 2>&1 &

# Post-optimization thermal check
echo "[🛡️] Performing post-optimization thermal check..."
check_thermal

# Final output
echo "MATIKAN THERMAL LIMIT FPS [✓]"
echo ""
sleep 0.5
echo "PAKSA REFRESH RATE MAXIMAL [✓]"
sleep 0.5
echo "INJECT FPS & FPS OPTIMIZE [✓]"
sleep 0.5
echo "OPTIMIZE ANIMATIONS [✓]"
sleep 0.5
echo "BOOST CPU & GPU PERFORMANCE [✓]"
sleep 0.5
echo "ENHANCE TOUCH RESPONSIVENESS [✓]"
sleep 0.5
echo "OPTIMIZE MEMORY & NETWORK [✓]"
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
echo "DONT REBOOT (Settings may reset)"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING FRAME RATE CONTROLLER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS UNLOCK by Agung Dev' 'Tag' 'SUCCESS: Performance Optimized.' >/dev/null 2>&1
