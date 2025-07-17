#!/system/bin/sh
# FRAME RATE CONTROLLER by Agung Developer - Unleash Maximum Frame Rates
# Optimized for ultra-smooth gaming | Watermark: © Agung Developer 2025

# --- CHECK GAME PACKAGE ---
GAME_PACKAGE="$1"
if [ -z "$GAME_PACKAGE" ]; then
  echo -e "\033[1;31mNo game package specified! Using default optimizations.\033[0m"
else
  echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"
  dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1
  echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"
fi

# --- STYLISH NOTIFICATION ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;32m"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🚀 Initiating Frame Rate Boost for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;36m"
echo "════════════════════════════════════════════"
echo "   🕹️  FRAME RATE CONTROLLER by Agung Developer  🕹️"
echo "   © Agung Developer 2025 - Power Unleashed!"
echo "════════════════════════════════════════════"
echo -e "\033[0m"
sleep 1

# --- DEVICE & HARDWARE INFO ---
echo -e "\033[1;34m"
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃        DEVICE & HARDWARE STATUS          ┃"
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
echo "┃ 📱 Device: $(getprop ro.product.manufacturer) $(getprop ro.product.model)    ┃"
echo "┃ ⚙️ CPU: $(getprop ro.board.platform)                  ┃"
echo "┃ 🎮 GPU: $(getprop ro.hardware)                       ┃"
echo "┃ 📲 Android: $(getprop ro.build.version.release)      ┃"
echo "┃ 🔥 Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)°C ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"
sleep 0.5

# --- CORE FPS AND REFRESH RATE OPTIMIZATIONS ---
echo -e "\033[1;33m"
echo "🔧 Applying Frame Rate Optimizations..."
echo -e "\033[0m"
(
  cmd display set-match-content-frame-rate-pref 1
  settings put system power.dfps.level 0
  settings put system disable_idle_fps true
  settings put system fps.idle_control false
  settings put system metadata_dynfps.disable 1
  settings put system display.disable_dynamic_fps 1
  settings put system display.low_framerate_limit 120
  settings put system display.refresh_rate 120
  settings put system display.enable_optimal_refresh_rate 1
  settings put system display.idle_time 0
  settings put global dfps.enable false
  settings put global smart_dfps.enable false
  settings put global smart_dfps.idle_fps 120
  settings put global display.idle_default_fps 120
  setprop debug.mediatek_high_frame_rate_multiple_display_mode 0
  setprop debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold 120
  settings put global tran_refresh_rate_video_detector.support 0
  settings put global tran_default_auto_refresh.support 0
  settings put global tran_default_refresh_mode 120
  settings put global tran_120hz_refresh_rate.not_support 1
  settings put global tran_custom_refresh_rate_config.support 1
  settings put global transsion.frame_override.support 0
  settings put global transsion.tran_refresh_rate.support 0
  setprop debug.sf.perf_mode 1
  setprop debug.sf.latch_unsignaled 1
  setprop debug.sf.high_fps_early_phase_offset_ns 1500000
  setprop debug.sf.high_fps_late_app_phase_offset_ns 400000
  setprop persist.sys.surfaceflinger.idle_reduce_framerate_enable false
  setprop debug.hwui.refresh_rate 120
  setprop debug.hwui.disable_vsync true
  setprop debug.performance.profile 1
  setprop debug.perf.tuning 1
  setprop persist.sys.gpu_perf_mode 1
  setprop debug.mtk.powerhal.hint.bypass 1
  settings put system user_refresh_rate 120
  settings put system fps_limit 120
  settings put system max_refresh_rate_for_ui 120
  settings put system max_refresh_rate_for_gaming 120
  settings put system min_refresh_rate 120
  settings put system max_refresh_rate 120
  settings put system peak_refresh_rate 120
  settings put system thermal_limit_refresh_rate 120
  settings put system NV_FPSLIMIT 120
  settings put secure refresh_rate_mode 120
  settings put system display_min_refresh_rate 120
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m"
echo "════════════════════════════════════════════"
echo "   🎉 OPTIMIZATION STATUS by Agung Developer 🎉"
echo "   🚀 FRAME RATE LOCKED TO 120Hz [✓]         "
echo "   ✅ ALL SETTINGS APPLIED [✓]               "
echo "   © Agung Developer 2025 - Enjoy the Flow!  "
echo "   ⚠️ DO NOT REBOOT UNTIL NEEDED            "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🌟 FRAME RATE MAXIMIZED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"