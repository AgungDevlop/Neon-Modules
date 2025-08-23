#!/system/bin/sh
# 🔒 FPS Reset Script - Mengembalikan pengaturan frame rate ke default (by Agung Developer)
# Aman untuk Root dan Non-Root
# Current date: August 23, 2025

# Function to check if a package is installed
check_package() {
    pm list packages | grep -q "$1" && return 0 || return 1
}

# Function to set settings with error checking
set_setting() {
    local scope=$1
    local key=$2
    local value=$3
    settings put "$scope" "$key" "$value" >/dev/null 2>&1 && echo "[✔] Reset $scope $key to $value" || echo "[!] Skipped $scope $key (not supported)"
}

# Function to reset property with error checking (root only)
reset_property() {
    local prop=$1
    local value=$2
    if getprop "$prop" >/dev/null 2>&1; then
        setprop "$prop" "$value" && echo "[✔] Reset $prop to $value" || echo "[✘] Failed to reset $prop"
    else
        echo "[!] Skipped $prop (not supported)"
    fi
}

# Function to check root access
check_root() {
    if [ $(id -u 2>/dev/null) -eq 0 ]; then
        echo "Yes"
        return 0
    else
        echo "No"
        return 1
    fi
}

# Initial notification
cmd notification post -S bigtext -t 'FPS RESET' 'Tag' 'Starting Reset to Default Settings.' >/dev/null 2>&1

echo ""
echo "█▓▒▒░░░FPS RESET by Agung Developer░░░▒▒▓█"
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
echo "│ 🛑 Root     : $(check_root) │"
echo "│ 🔗 SELinux  : $(getenforce 2>/dev/null || echo 'N/A') │"
echo "└───────────────────────────────────────┘"
echo ""
echo "█▓▒▒░░░WELCOME TO FPS RESET░░░▒▒▓█"
echo ""
sleep 0.5
sleep 3

# Reset app restrictions
echo "🛡️ Mengembalikan izin aplikasi sistem..."
whitelist="com.android.systemui com.google.android.gms com.android.settings com.android.vending com.android.launcher"

for a in $(cmd package list packages -s | cut -d ":" -f2); do
    echo "$whitelist" | grep -q "$a" && echo "⏩ Skip $a (whitelist)" && continue
    cmd appops set "$a" RUN_IN_BACKGROUND default >/dev/null 2>&1 && echo "[✔] Restored $a RUN_IN_BACKGROUND" || echo "[!] Skipped $a RUN_IN_BACKGROUND"
    cmd appops set "$a" START_FOREGROUND default >/dev/null 2>&1 || echo "[!] Skipped $a START_FOREGROUND"
    cmd appops set "$a" INSTANT_APP_START_FOREGROUND default >/dev/null 2>&1 || echo "[!] Skipped $a INSTANT_APP_START_FOREGROUND"
    cmd appops set "$a" WAKE_LOCK default >/dev/null 2>&1 || echo "[!] Skipped $a WAKE_LOCK"
    cmd appops set "$a" RUN_ANY_IN_BACKGROUND default >/dev/null 2>&1 || echo "[!] Skipped $a RUN_ANY_IN_BACKGROUND"
    am set-standby-bucket "$a" active >/dev/null 2>&1 || echo "[!] Skipped $a standby bucket"
done

echo "✅ Semua izin aplikasi sistem telah dikembalikan."

# Reset Frame Rate Optimizations (Non-Root Safe)
(
    cmd display set-match-content-frame-rate-pref 0 >/dev/null 2>&1 && echo "[✔] Disabled match content frame rate preference"
    set_setting system display.refresh_rate 0
    set_setting system min_refresh_rate 0
    set_setting system max_refresh_rate 0
    set_setting system peak_refresh_rate 0
    set_setting secure user_refresh_rate 0
    set_setting secure miui_refresh_rate 0
    set_setting global min_fps 0
    set_setting global max_fps 0
    set_setting system display.enable_optimal_refresh_rate 0
    set_setting system display.disable_dynamic_fps 0
    set_setting system display.low_framerate_limit 0
    set_setting system display.defer_fps_frame_count 0
    set_setting system display.large_comp_hint_fps 0
    set_setting system display.enable_pref_hint_for_low_fps 0
    set_setting system display.enable_idle_content_fps_hint 1
    set_setting system display.refresh_rate_changeable 1
    set_setting system display.idle_time -1
    set_setting system display.idle_time_inactive -1
    set_setting global dfps.enable true
    set_setting global smart_dfps.enable true
    set_setting global fps.switch.default true
    set_setting global smart_dfps.idle_fps 0
    set_setting global display.idle_default_fps 0
    set_setting global smart_dfps.app_switch_fps 0
    set_setting global display.fod_monitor_default_fps 0
    set_setting global tran_refresh_rate_video_detector.support 1
    set_setting global tran_default_auto_refresh.support 1
    set_setting global tran_default_refresh_mode 0
    set_setting global tran_low_battery_60hz_refresh_rate.support 1
    set_setting global tran_90hz_refresh_rate.not_support 1
    set_setting global tran_custom_refresh_rate_config.support 0
    set_setting global transsion.frame_override.support 1
    set_setting global transsion.tran_refresh_rate.support 1
    set_setting global surface_flinger.use_content_detection_for_refresh_rate true
    set_setting global media.recorder-max-base-layer-fps 0
    set_setting global vendor.fps.switch.default false
    set_setting system vendor.display.default_fps 0
    set_setting system vendor.display.idle_default_fps 0
    set_setting system vendor.display.enable_optimize_refresh 0
    set_setting system vendor.display.video_or_camera_fps.support false
    set_setting system game_driver_min_frame_rate 0
    set_setting system game_driver_max_frame_rate 0
    set_setting system game_driver_power_saving_mode 1
    set_setting system game_driver_frame_skip_enable 1
    set_setting system game_driver_vsync_enable 1
    set_setting system game_driver_gpu_mode 0
    set_setting system game_driver_fps_limit 0
    set_setting system user_refresh_rate 0
    set_setting system fps_limit 0
    set_setting system max_refresh_rate_for_ui 0
    set_setting system hwui_refresh_rate 0
    set_setting system max_refresh_rate_for_gaming 0
    set_setting system fstb_target_fps_margin_high_fps 0
    set_setting system fstb_target_fps_margin_low_fps 0
    set_setting system gcc_fps_margin 0
    set_setting system power.dfps.level -1
    set_setting system disable_idle_fps false
    set_setting system disable_idle_fps.threshold 0
    set_setting system fps.idle_control true
    set_setting system metadata_dynfps.disabel 0
    set_setting system enable_dpps_dynamic_fps 1
    set_setting system display.disable_metadata_dynamic_fps 0
    set_setting system thermal_limit_refresh_rate 0
    set_setting system NV_FPSLIMIT 0
    set_setting system tran_low_battery_60hz_refresh_rate.support 1
    set_setting system tran_refresh_mode 0
    set_setting system last_tran_refresh_mode_in_refresh_setting 0
    set_setting system display_min_refresh_rate 0
    set_setting system min_frame_rate 0
    set_setting system max_frame_rate 0
    set_setting system tran_need_recovery_refresh_mode 0
    set_setting secure refresh_rate_mode 0
) > /dev/null 2>&1 &

# Reset Root-Only Properties (if root access is available)
if check_root; then
    (
        reset_property debug.mediatek_high_frame_rate_multiple_display_mode 1
        reset_property debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold 0
        reset_property debug.sys.display.fps 0
        reset_property debug.sys.display_refresh_rate 0
        reset_property debug.sys.game.minfps 0
        reset_property debug.sys.game.maxfps 0
        reset_property debug.sys.game.minframerate 0
        reset_property debug.sys.game.maxframerate 0
        reset_property debug.sys.min_refresh_rate 0
        reset_property debug.sys.max_refresh_rate 0
        reset_property debug.sys.peak_refresh_rate 0
        reset_property debug.sys.sf.fps 0
        reset_property debug.sys.smartfps 0
        reset_property debug.sys.vsync_optimization_enable true
        reset_property debug.sys.hwui.dyn_vsync 1
        reset_property debug.sys.vsync true
        reset_property debug.sys.hwui.fps_mode 0
        reset_property debug.sys.first.frame.accelerates false
        reset_property debug.sys.fps_unlock_allowed 0
        reset_property debug.sys.display.max_fps 0
        reset_property debug.sys.video.max.fps 0
        reset_property debug.sys.surfaceflinger.idle_reduce_framerate_enable true
        reset_property sys.display.fps 0
        reset_property sys.display_refresh_rate 0
        reset_property sys.game.minfps 0
        reset_property sys.game.maxfps 0
        reset_property sys.game.minframerate 0
        reset_property sys.game.maxframerate 0
        reset_property sys.min_refresh_rate 0
        reset_property sys.max_refresh_rate 0
        reset_property sys.peak_refresh_rate 0
        reset_property sys.sf.fps 0
        reset_property sys.smartfps 0
        reset_property sys.vsync_optimization_enable true
        reset_property sys.hwui.dyn_vsync 1
        reset_property sys.vsync true
        reset_property sys.hwui.fps_mode 0
        reset_property sys.first.frame.accelerates false
        reset_property sys.fps_unlock_allowed 0
        reset_property sys.display.max_fps 0
        reset_property sys.video.max.fps 0
        reset_property sys.surfaceflinger.idle_reduce_framerate_enable true
        reset_property debug.hwui.refresh_rate 0
        reset_property debug.sf.set_idle_timer_ms 0
        reset_property debug.sf.latch_unsignaled 0
        reset_property debug.sf.high_fps_early_phase_offset_ns 0
        reset_property debug.sf.high_fps_late_app_phase_offset_ns 0
        reset_property debug.graphics.game_default_frame_rate 0
        reset_property debug.graphics.game_default_frame_rate.disabled true
        reset_property persist.sys.gpu_perf_mode 0
        reset_property debug.mtk.powerhal.hint.bypass 0
        reset_property persist.sys.surfaceflinger.idle_reduce_framerate_enable true
        reset_property debug.sf.perf_mode 0
        reset_property debug.hwui.disable_vsync false
        reset_property debug.performance.profile 0
        reset_property debug.perf.tuning 0
    ) > /dev/null 2>&1 &
fi

echo "RESET THERMAL LIMIT FPS [✓]"
echo ""
sleep 0.5
echo "RESET REFRESH RATE TO DEFAULT [✓]"
sleep 0.5
echo "CLEAR FPS OPTIMIZATIONS [✓]"
echo ""
sleep 0.5
echo "ALL SETTINGS RESET [✓]"
echo ""
sleep 0.5
echo "‼️PENGATURAN KEMBALI KE DEFAULT‼️"
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "REBOOT RECOMMENDED"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING FPS RESET SCRIPT ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS RESET' 'Tag' 'SUCCESS: Settings Restored to Default.' >/dev/null 2>&1
