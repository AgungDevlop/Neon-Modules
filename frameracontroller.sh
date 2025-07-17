#!/system/bin/sh
# 🔒 Frame Rate Controller - Optimasi frame rate untuk performa (by Agung Developer)
# Integrasi script SHAMIKO

echo "🛡️ Membatasi aplikasi sistem... Harap tunggu."

# WHITELIST: Jangan disentuh
whitelist="com.android.systemui com.google.android.gms com.android.settings com.android.vending"

for a in $(cmd package list packages -s | cut -d ":" -f2); do
  echo "$whitelist" | grep -q "$a" && echo "⏩ Skip $a (whitelist)" && continue
  cmd appops set $a RUN_IN_BACKGROUND deny
  cmd appops set $a START_FOREGROUND deny
  cmd appops set $a INSTANT_APP_START_FOREGROUND deny
  cmd appops set $a WAKE_LOCK deny
  cmd appops set $a RUN_ANY_IN_BACKGROUND deny
  am set-standby-bucket $a rare
  echo "✅ $a dibatasi"
done

echo "✅ Semua aplikasi sistem telah dibatasi secara aman."

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting Frame Rate Optimization.'
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
echo "│ 🔥 Thermal  : $(cat /sys/class/thermal/thermal_zone0/temp)°C │"
echo "│ 🔰 Kernel   : $(uname -r) │"
echo "│ 🔹 Build    : $(getprop ro.build.display.id) │"
echo "│ 🛑 Root     : $(if [ $(id -u) -eq 0 ]; then echo 'Yes'; else echo 'No'; fi) │"
echo "│ 🔗 SELinux  : $(getenforce) │"
echo "└───────────────────────────────────────┘"
echo ""
echo "█▓▒▒░░░WELCOME TO FRAME RATE OPTIMIZATION░░░▒▒▓█"
echo ""
sleep 0.5
echo ""
sleep 3

(
# Optimasi Frame Rate
cmd display set-match-content-frame-rate-pref 1
settings put system power.dfps.level 0
settings put system disable_idle_fps true
settings put system disable_idle_fps.threshold 1
settings put system fps.idle_control false
settings put system metadata_dynfps.disabel 1
settings put system enable_dpps_dynamic_fps 0
settings put system display.disable_dynamic_fps 1
settings put system display.disable_metadata_dynamic_fps 1
settings put system display.low_framerate_limit 120
settings put system display.defer_fps_frame_count 2
settings put system display.refresh_rate 120
settings put system display.large_comp_hint_fps 120
settings put system display.enable_pref_hint_for_low_fps 1
settings put system display.enable_optimal_refresh_rate 1
settings put system display.enable_idle_content_fps_hint 0
settings put system display.refresh_rate_changeable 0
settings put system display.disable_mitigated_fps 1
settings put system display.idle_time 0
settings put system display.idle_time_inactive 0
settings put global dfps.enable false
settings put global smart_dfps.enable false
settings put global fps.switch.thermal false
settings put global fps.switch.default false
settings put global smart_dfps.idle_fps 120
settings put global display.idle_default_fps 120
settings put global smart_dfps.app_switch_fps 120
settings put global display.fod_monitor_default_fps 120
setprop debug.mediatek_high_frame_rate_multiple_display_mode 0
setprop debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold 120
settings put global tran_refresh_rate_video_detector.support 0
settings put global tran_default_auto_refresh.support 0
settings put global tran_default_refresh_mode 120
settings put global tran_low_battery_60hz_refresh_rate.support 0
settings put global tran_90hz_refresh_rate.not_support 0
settings put system surfaceflinger.idle_reduce_framerate_enable false
settings put system surfaceflinger.idle_reduce_framerate_enable no
settings put global tran_custom_refresh_rate_config.support 1
settings put global transsion.frame_override.support 0
settings put global transsion.tran_refresh_rate.support 0
setprop debug.sys.display.fps 120
setprop debug.sys.display_refresh_rate 120
setprop debug.sys.game.minfps 120
setprop debug.sys.game.maxfps 120
setprop debug.sys.game.minframerate 120
setprop debug.sys.game.maxframerate 120
setprop debug.sys.min_refresh_rate 120
setprop debug.sys.max_refresh_rate 120
setprop debug.sys.peak_refresh_rate 120
setprop debug.sys.sf.fps 120
setprop debug.sys.smartfps 1
setprop debug.sys.display.min_refresh_rate 120
setprop debug.sys.vsync_optimization_enable false
setprop debug.sys.hwui.dyn_vsync 0
setprop debug.sys.vsync false
setprop debug.sys.hwui.fps_mode 1
setprop debug.sys.first.frame.accelerates true
setprop debug.sys.fps_unlock_allowed 120
setprop debug.sys.display.max_fps 120
setprop debug.sys.video.max.fps 120
setprop debug.sys.surfaceflinger.idle_reduce_framerate_enable false
setprop sys.display.fps 120
setprop sys.display_refresh_rate 120
setprop sys.game.minfps 120
setprop sys.game.maxfps 120
setprop sys.game.minframerate 120
setprop sys.game.maxframerate 120
setprop sys.min_refresh_rate 120
setprop sys.max_refresh_rate 120
setprop sys.peak_refresh_rate 120
setprop sys.sf.fps 120
setprop sys.smartfps 1
setprop sys.display.min_refresh_rate 120
setprop sys.vsync_optimization_enable false
setprop sys.hwui.dyn_vsync 0
setprop sys.vsync false
setprop sys.hwui.fps_mode 1
setprop sys.first.frame.accelerates true
setprop sys.fps_unlock_allowed 120
setprop sys.display.max_fps 120
setprop sys.video.max.fps 120
setprop sys.surfaceflinger.idle_reduce_framerate_enable false
settings put global refresh_rate_mode 1
settings put global refresh_rate_switching_type 1
settings put global refresh_rate_force_high 1
setprop debug.hwui.refresh_rate 120
setprop debug.sf.perf_mode 1
settings put global surface_flinger.use_content_detection_for_refresh_rate false
settings put global media.recorder-max-base-layer-fps 120
settings put global vendor.fps.switch.default true
settings put system vendor.disable_idle_fps true
settings put system vendor.display.default_fps 120
settings put system vendor.display.idle_default_fps 120
settings put system vendor.display.enable_optimize_refresh 1
settings put system vendor.display.video_or_camera_fps.support true
setprop debug.hwui.refresh_rate 120
setprop debug.sf.set_idle_timer_ms 500
setprop debug.sf.latch_unsignaled 1
setprop debug.sf.high_fps_early_phase_offset_ns 2000000
setprop debug.sf.high_fps_late_app_phase_offset_ns 500000
settings put system game_driver_min_frame_rate 120
settings put system game_driver_max_frame_rate 120
settings put system game_driver_power_saving_mode 0
settings put system game_driver_frame_skip_enable 0
settings put system game_driver_vsync_enable 0
settings put system game_driver_gpu_mode 1
settings put system game_driver_fps_limit 120
setprop debug.graphics.game_default_frame_rate 120
setprop debug.graphics.game_default_frame_rate.disabled false
setprop persist.sys.gpu_perf_mode 1
setprop debug.mtk.powerhal.hint.bypass 1
setprop persist.sys.surfaceflinger.idle_reduce_framerate_enable false
setprop sys.surfaceflinger.idle_reduce_framerate_enable false
setprop debug.sf.perf_mode 1
settings put global refresh.active 1
setprop debug.hwui.disable_vsync true
setprop debug.performance.profile 1
setprop debug.perf.tuning 1
settings put system user_refresh_rate 120
settings put system fps_limit 120
settings put system max_refresh_rate_for_ui 120
settings put system hwui_refresh_rate 120
settings put system display_refresh_rate 120
settings put system max_refresh_rate_for_gaming 120
settings put system fstb_target_fps_margin_high_fps 20
settings put system fstb_target_fps_margin_low_fps 20
settings put system gcc_fps_margin 10
settings put system tran_low_battery_60hz_refresh_rate.support 0
settings put system vendor.display.refresh_rate 120
settings put system user_refresh_rate 1
settings put system sf.refresh_rate 120
settings put secure user_refresh_rate 1
settings put secure miui_refresh_rate 120
settings put system min_frame_rate 120
settings put system max_frame_rate 120
settings put system tran_refresh_mode 120
settings put system last_tran_refresh_mode_in_refresh_setting 120
settings put global min_fps 120
settings put global max_fps 120
settings put system tran_need_recovery_refresh_mode 120
settings put system display_min_refresh_rate 120
settings put system min_refresh_rate 120
settings put system max_refresh_rate 120
settings put system peak_refresh_rate 120
settings put secure refresh_rate_mode 120
settings put system thermal_limit_refresh_rate 120
settings put system NV_FPSLIMIT 120
settings put system fps.limit.is.now locked
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
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Frame Rate Optimized.'