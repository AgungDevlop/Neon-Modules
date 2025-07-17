#!/system/bin/sh
# FRAME RATE CONTROLLER by Agung Developer - Unleash Maximum Frame Rates
# Optimized for ultra-smooth gaming and app performance | Watermark: © Agung Developer 2025

# --- STYLISH NOTIFICATION ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;32m" # Green text
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🚀 Initiating Frame Rate Boost by © Agung Developer 2025' --icon "$ICON_URL"
echo -e "\033[0m" # Reset color

# --- ASCII ART HEADER ---
echo -e "\033[1;36m" # Cyan text
echo "════════════════════════════════════════════"
echo "   🕹️  FRAME RATE CONTROLLER by Agung Developer  🕹️"
echo "   © Agung Developer 2025 - Power Unleashed!"
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
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"
sleep 0.5

# --- ADVANCED FRAME RATE OPTIMIZATION ---
echo -e "\033[1;33m" # Yellow text
echo "🔧 Initiating Maximum Frame Rate Optimization..."
echo -e "\033[0m"
(
  # Force 120Hz refresh rate and disable dynamic FPS
  settings put system display.refresh_rate 120
  settings put system max_refresh_rate 120
  settings put system min_refresh_rate 120
  settings put system user_refresh_rate 120
  settings put system display.low_framerate_limit 120
  settings put system disable_idle_fps true
  settings put system fps.idle_control false
  settings put system metadata_dynfps.disable 1
  settings put system display.disable_dynamic_fps 1

  # SurfaceFlinger and HWUI tweaks
  setprop debug.sf.perf_mode 1
  setprop debug.sf.high_fps_early_phase_offset_ns 1500000
  setprop debug.sf.latch_unsignaled 1
  setprop debug.hwui.refresh_rate 120
  setprop debug.hwui.disable_vsync true
  setprop persist.sys.surfaceflinger.idle_reduce_framerate_enable false

  # MediaTek and generic optimizations
  setprop debug.mediatek_high_frame_rate_multiple_display_mode 0
  setprop debug.mediatek_high_frame_rate_sf_set_big_core_fps_threshold 120
  setprop debug.performance.profile 1
  setprop debug.perf.tuning 1
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m" # Green text
echo "════════════════════════════════════════════"
echo "   🎉 OPTIMIZATION STATUS by Agung Developer 🎉"
echo "   🚀 FRAME RATE LOCKED TO 120Hz [✓]         "
echo "   ✅ ALL SETTINGS APPLIED [✓]               "
echo "   © Agung Developer 2025 - Enjoy the Flow!  "
echo "   ⚠️ DO NOT REBOOT UNTIL NEEDED            "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

# --- FINAL NOTIFICATION ---
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🌟 FRAME RATE MAXIMIZED by © Agung Developer 2025' --icon "$ICON_URL"
