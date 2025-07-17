#!/system/bin/sh
# STOP MODULE by Agung Developer - Halt All Performance Modules
# Resets all FPS Injector settings to default | Watermark: © Agung Developer 2025

# --- STYLISH NOTIFICATION ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;31m" # Red text for stop action
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🛑 Initiating Full Module Shutdown by © Agung Developer 2025' --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;31m" # Red text
echo "════════════════════════════════════════════"
echo "   🛑  STOP MODULE by Agung Developer  🛑"
echo "   © Agung Developer 2025 - Reset Master!"
echo "════════════════════════════════════════════"
echo -e "\033[0m"
sleep 1

# --- DEVICE & HARDWARE INFO ---
echo -e "\033[1;34m" # Blue text
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃        DEVICE & HARDWARE STATUS          ┃"
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
echo "┃ 📱 Device: $(getprop ro.product.manufacturer) $(getprop ro.product.model)    ┃"
echo "┃ ⚙️ CPU: $(getprop ro.board.platform)                  ┃"
echo "┃ 🎮 GPU: $(getprop ro.hardware)                       ┃"
echo "┃ 📲 Android: $(getprop ro.build.version.release)      ┃"
echo "┃ 🔥 Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)°C ┃"
echo "┃ 🔰 Kernel: $(uname -r)                              ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"
sleep 0.5

# --- RESET ALL MODULES ---
echo -e "\033[1;33m" # Yellow text
echo "🔧 Initiating Full System Reset for All Modules..."
echo -e "\033[0m"

# Reset Frame Rate Controller
(
  settings reset system display.refresh_rate
  settings reset system max_refresh_rate
  settings reset system min_refresh_rate
  settings reset system user_refresh_rate
  settings reset system display.low_framerate_limit
  settings reset system disable_idle_fps
  settings reset system fps.idle_control
  settings reset system metadata_dynfps.disable
  settings reset system display.disable_dynamic_fps
  setprop debug.sf.perf_mode 0
  setprop debug.sf.high_fps_early_phase_offset_ns ""
  setprop debug.sf.latch_unsignaled 0
  setprop debug.hwui.refresh_rate ""
  setprop debug.hwui.disable_vsync false
  setprop persist.sys.surfaceflinger.idle_reduce_framerate_enable ""
  setprop debug.mediatek_high_frame_rate_multiple_display_mode ""
  setprop debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold ""
) > /dev/null 2>&1 &

# Reset Thermal Controller
(
  echo 1 > /sys/class/thermal/thermal_zone0/mode
  echo "enabled" > /sys/class/thermal/thermal_zone0/policy
  echo 1 > /sys/module/msm_thermal/parameters/enabled
  settings put global low_power 1
  echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
) > /dev/null 2>&1 &

# Reset CPU Optimizer
(
  for cpu_gov_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do [ -f "$cpu_gov_path" ] && echo "ondemand" > "$cpu_gov_path"; done
  for cpu_max_freq_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do [ -f "$cpu_max_freq_path" ] && echo 0 > "$cpu_max_freq_path"; done
  setprop debug.performance.profile 0
) > /dev/null 2>&1 &

# Reset GPU Enhancer
(
  echo "ondemand" > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null
  echo 0 > /sys/class/kgsl/kgsl-3d0/force_bus_on
  setprop persist.sys.gpu_perf_mode 0
) > /dev/null 2>&1 &

# Reset RAM Cleaner
(
  echo 0 > /proc/sys/vm/drop_caches
  am broadcast -a android.intent.action.BOOT_COMPLETED
) > /dev/null 2>&1 &

# Reset Battery Saver
(
  settings put global low_power 0
  echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
) > /dev/null 2>&1 &

# Reset Network Booster
(
  setprop net.tcp.buffersize.wifi ""
  settings put global mobile_data_always_on 0
  setprop net.rmnet0.dns1 ""
) > /dev/null 2>&1 &

# Reset Game Mode
(
  setprop debug.performance.profile 0
  echo 1 > /sys/module/lowmemorykiller/parameters/enable_lmk
  settings reset system max_refresh_rate
) > /dev/null 2>&1 &

# Reset Storage Optimizer
(
  echo 0 > /proc/sys/vm/drop_caches
  fstrim -v /data
  echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
) > /dev/null 2>&1 &

# Reset Anti-Lag
(
  echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  echo 1000000 > /sys/kernel/sched/sched_latency_ns
  setprop debug.performance.profile 0
) > /dev/null 2>&1 &

# Reset Memory Compressor
(
  echo 60 > /proc/sys/vm/swappiness
  echo 100 > /proc/sys/vm/vfs_cache_pressure
  echo 0 > /proc/sys/vm/drop_caches
) > /dev/null 2>&1 &

# Reset IO Tuner
(
  echo "cfq" > /sys/block/mmcblk0/queue/scheduler
  echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
  echo 64 > /sys/block/mmcblk0/queue/nr_requests
) > /dev/null 2>&1 &

# Reset Power Mode
(
  settings put global powersaving_mode_enabled 1
  echo 0 > /sys/module/cpu_boost/parameters/input_boost_freq
  setprop debug.performance.profile 0
) > /dev/null 2>&1 &

# Reset Process Manager
(
  am broadcast -a android.intent.action.BOOT_COMPLETED
  pm trim-caches --reset
  echo 1000000 > /proc/sys/kernel/sched_rt_runtime_us
) > /dev/null 2>&1 &

# Reset Display Tuner
(
  settings reset system display.refresh_rate
  setprop debug.sf.latch_unsignaled 0
  setprop debug.hwui.disable_vsync false
) > /dev/null 2>&1 &

# Reset Cache Clearer
(
  pm trim-caches --reset
  echo 0 > /proc/sys/vm/drop_caches
) > /dev/null 2>&1 &

# Reset Kernel Tweaker
(
  echo 1 > /proc/sys/kernel/sched_schedstats
  echo 2 > /proc/sys/kernel/perf_event_paranoid
  setprop debug.performance.profile 0
) > /dev/null 2>&1 &

# Reset FPS Unlocker
(
  settings reset system max_refresh_rate
  setprop debug.sf.high_fps_early_phase_offset_ns ""
  setprop debug.hwui.refresh_rate ""
) > /dev/null 2>&1 &

# Reset Vibration Control
(
  settings put system haptic_feedback_enabled 1
  echo 1 > /sys/class/timed_output/vibrator/enable
) > /dev/null 2>&1 &

# Reset Sensor Optimizer
(
  setprop debug.sensor.hal.period 100
  echo 1 > /sys/class/sensors/sensor0/enable
) > /dev/null 2>&1 &

# Reset Background Limiter
(
  dumpsys deviceidle whitelist +$(cmd package list packages -3 | sed 's/package://g')
  echo 1000000 > /proc/sys/kernel/sched_rt_runtime_us
) > /dev/null 2>&1 &

# Reset Audio Enhancer
(
  setprop audio.offload.enable 0
  echo 0 > /sys/class/sound_control/headphone_gain
  setprop audio.deep_buffer.media 0
) > /dev/null 2>&1 &

# Reset Boot Optimizer
(
  echo 1 > /sys/module/lowmemorykiller/parameters/enable_lmk
  echo 1 > /sys/kernel/boot_boost
  setprop persist.sys.boot_completed 0
) > /dev/null 2>&1 &

# Reset Log Cleaner
(
  logcat -c
  dmesg -c
  mkdir -p /data/system/dropbox
) > /dev/null 2>&1 &

# Reset Touch Sensitivity
(
  setprop debug.touch.sensitivity 1
  echo 5 > /sys/class/touchscreen/touch_threshold
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m" # Green text
echo "════════════════════════════════════════════"
echo "   🎉 RESET STATUS by Agung Developer 🎉"
echo "   🛑 ALL MODULES DISABLED [✓]              "
echo "   ✅ ALL SETTINGS RESET TO DEFAULT [✓]      "
echo "   © Agung Developer 2025 - System Restored!"
echo "   ⚠️ REBOOT DEVICE FOR STABILITY          "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

# --- FINAL NOTIFICATION ---
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🛑 ALL MODULES STOPPED by © Agung Developer 2025' --icon "$ICON_URL"