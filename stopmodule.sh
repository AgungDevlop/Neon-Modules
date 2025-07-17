#!/system/bin/sh
# ♻️ Stop Module - Menghentikan semua modul performa (by Agung Developer)

echo "🔓 Mengembalikan pengaturan aplikasi sistem..."

# WHITELIST: Jangan disentuh
whitelist="com.android.systemui com.google.android.gms com.android.settings com.android.vending"

for a in $(cmd package list packages -s | cut -d ":" -f2); do
  echo "$whitelist" | grep -q "$a" && echo "⏩ Skip $a (whitelist)" && continue
  cmd appops set $a RUN_IN_BACKGROUND allow
  cmd appops set $a START_FOREGROUND allow
  cmd appops set $a INSTANT_APP_START_FOREGROUND allow
  cmd appops set $a WAKE_LOCK allow
  cmd appops set $a RUN_ANY_IN_BACKGROUND allow
  am set-standby-bucket $a active
  echo "✅ $a dipulihkan"
done

echo "✅ Semua pengaturan aplikasi sistem telah dipulihkan!"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting Configuration.'
echo ""
echo "█▓▒▒░░░FPS INJECTOR░░░▒▒▓█"
echo ""
sleep 0.5
echo "DEVICE AND HARDWARE INFO"
sleep 0.5
echo "DEVICE $(getprop ro.product.brand)"
sleep 0.5
echo "MODEL $(getprop ro.product.model)"
sleep 0.5
echo "CPU $(getprop ro.hardware)"
sleep 0.5
echo "GPU $(getprop ro.hardware.egl)"
sleep 0.5
echo "SDK $(getprop ro.build.version.sdk)"
echo ""
echo "█▓▒▒░░░WELCOME TO UNINSTALL░░░▒▒▓█"
echo ""
sleep 0.5
echo ""
sleep 3

(
# Reset semua pengaturan
cmd display set-match-content-frame-rate-pref 0
settings delete system power.dfps.level
settings delete system disable_idle_fps
settings delete system disable_idle_fps.threshold
settings delete system fps.idle_control
settings delete system metadata_dynfps.disabel
settings delete system enable_dpps_dynamic_fps
settings delete system display.disable_dynamic_fps
settings delete system display.disable_metadata_dynamic_fps
settings delete system display.low_framerate_limit
settings delete system display.defer_fps_frame_count
settings delete system display.refresh_rate
settings delete system display.large_comp_hint_fps
settings delete system display.enable_pref_hint_for_low_fps
settings delete system display.enable_optimal_refresh_rate
settings delete system display.enable_idle_content_fps_hint
settings delete system display.refresh_rate_changeable
settings delete system display.disable_mitigated_fps
settings delete system display.idle_time
settings delete system display.idle_time_inactive
settings delete global dfps.enable
settings delete global smart_dfps.enable
settings delete global fps.switch.thermal
settings delete global fps.switch.default
settings delete global smart_dfps.idle_fps
settings delete global display.idle_default_fps
settings delete global smart_dfps.app_switch_fps
settings delete global display.fod_monitor_default_fps
setprop debug.mediatek_high_frame_rate_multiple_display_mode ""
setprop debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold ""
settings delete global tran_refresh_rate_video_detector.support
settings delete global tran_default_auto_refresh.support
settings delete global tran_default_refresh_mode
settings delete global tran_low_battery_60hz_refresh_rate.support
settings delete global tran_90hz_refresh_rate.not_support
settings delete system surfaceflinger.idle_reduce_framerate_enable
settings delete global tran_custom_refresh_rate_config.support
settings delete global transsion.frame_override.support
settings delete global transsion.tran_refresh_rate.support
setprop debug.sys.display.fps ""
setprop debug.sys.display_refresh_rate ""
setprop debug.sys.game.minfps ""
setprop debug.sys.game.maxfps ""
setprop debug.sys.game.minframerate ""
setprop debug.sys.game.maxframerate ""
setprop debug.sys.min_refresh_rate ""
setprop debug.sys.max_refresh_rate ""
setprop debug.sys.peak_refresh_rate ""
setprop debug.sys.sf.fps ""
setprop debug.sys.smartfps ""
setprop debug.sys.display.min_refresh_rate ""
setprop debug.sys.vsync_optimization_enable ""
setprop debug.sys.hwui.dyn_vsync ""
setprop debug.sys.vsync ""
setprop debug.sys.hwui.fps_mode ""
setprop debug.sys.first.frame.accelerates ""
setprop debug.sys.fps_unlock_allowed ""
setprop debug.sys.display.max_fps ""
setprop debug.sys.video.max.fps ""
setprop debug.sys.surfaceflinger.idle_reduce_framerate_enable ""
settings delete global refresh_rate_mode
settings delete global refresh_rate_switching_type
settings delete global refresh_rate_force_high
setprop debug.hwui.refresh_rate ""
setprop debug.sf.perf_mode ""
settings delete global surface_flinger.use_content_detection_for_refresh_rate
settings delete global media.recorder-max-base-layer-fps
settings delete global vendor.fps.switch.default
settings delete global vendor.display.default_fps
settings delete global refresh.active
settings delete system vendor.disable_idle_fps
settings delete system vendor.display.idle_default_fps
settings delete system vendor.display.enable_optimize_refresh
settings delete system vendor.display.video_or_camera_fps.support
settings delete system game_driver_min_frame_rate
settings delete system game_driver_max_frame_rate
settings delete system game_driver_power_saving_mode
settings delete system game_driver_frame_skip_enable
settings delete system game_driver_vsync_enable
settings delete system game_driver_gpu_mode
settings delete system game_driver_fps_limit
setprop debug.hwui.refresh_rate ""
setprop debug.sf.set_idle_timer_ms ""
setprop debug.sf.latch_unsignaled ""
setprop debug.sf.high_fps_early_phase_offset_ns ""
setprop debug.sf.high_fps_late_app_phase_offset_ns ""
setprop debug.graphics.game_default_frame_rate ""
setprop debug.graphics.game_default_frame_rate.disabled ""
setprop persist.sys.gpu_perf_mode ""
setprop debug.mtk.powerhal.hint.bypass ""
setprop persist.sys.surfaceflinger.idle_reduce_framerate_enable ""
setprop sys.surfaceflinger.idle_reduce_framerate_enable ""
setprop debug.sf.perf_mode ""
setprop debug.hwui.disable_vsync ""
setprop debug.performance.profile ""
setprop debug.perf.tuning ""
settings delete system user_refresh_rate
settings delete system fps_limit
settings delete system max_refresh_rate_for_ui
settings delete system hwui_refresh_rate
settings delete system display_refresh_rate
settings delete system max_refresh_rate_for_gaming
settings put system peak_refresh_rate 60
settings delete system thermal_limit_refresh_rate
settings delete system max_refresh_rate
settings delete system min_refresh_rate
echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
setprop persist.sys.cpu.boost 0
echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/governor
setprop debug.gpu.perf_mode 0
setprop persist.sys.gpu_perf_mode 0
sync
echo 0 > /proc/sys/vm/drop_caches
setprop persist.sys.lowmemorykiller 1
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
setprop net.tcp.delack 1
setprop persist.sys.net.boost 0
settings put global wifi_scan_always_enabled 1
settings put global mobile_data_always_on 1
settings put system game_mode 0
setprop debug.game.perf_mode 0
setprop persist.sys.game_mode 0
echo deadline > /sys/block/mmcblk0/queue/scheduler
setprop persist.sys.storage.optimize 0
echo 0 > /proc/sys/kernel/sched_tunable_scaling
setprop persist.sys.sched.optimize 0
setprop debug.sys.lag_reducer 0
echo 0 > /proc/sys/vm/swappiness
setprop persist.sys.memory.compress 0
echo deadline > /sys/block/mmcblk0/queue/scheduler
setprop persist.sys.io.optimize 0
setprop persist.sys.power.mode powersave
settings put global power_mode 0
setprop persist.sys.process.manager 0
settings put system touch_sensitivity 0
setprop persist.sys.touch.sensitivity 0
setprop persist.sys.audio.enhance 0
settings put system sound_effects_enabled 0
setprop debug.audio.hifi 0
setprop persist.sys.boot.optimize 0
settings put global boot_animation 1
setprop persist.sys.log.clear 0
setprop persist.sys.vibration 1
settings put system vibrate_on_touch 1
setprop persist.sys.sensor.optimize 0
settings put global max_cached_processes 128
setprop persist.sys.background.limit 0
) > /dev/null 2>&1 &

echo "DELETE ALL STRING [✓]"
echo ""
sleep 0.5
echo "‼️REBOOT DEVICE ‼️"
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "DONE UNINSTALL"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING STOP MODULE ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: All Modules Stopped.'