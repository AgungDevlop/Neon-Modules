#!/system/bin/sh
# FRAME RATE CONTROLLER by Agung Developer - Optimizes frame rate for gaming and apps
# Watermark: Agung Developer

# --- NOTIFICATION AND HEADER ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting Frame Rate Optimization by Agung Developer' --icon "$ICON_URL"

echo ""
echo "█▓▒▒░░░FRAME RATE CONTROLLER by Agung Developer░░░▒▒▓█"
echo ""
sleep 0.5

# --- DEVICE & HARDWARE INFO ---
echo "┌───────────────────────────────┐"
echo "│   DEVICE & HARDWARE INFO      │"
echo "├───────────────────────────────┤"
echo "│ 📱 Device: $(getprop ro.product.manufacturer) $(getprop ro.product.model)"
echo "│ ⚙️ CPU: $(getprop ro.board.platform)"
echo "│ 🎮 GPU: $(getprop ro.hardware)"
echo "│ 📲 Android: $(getprop ro.build.version.release)"
echo "│ 🔥 Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)°C"
echo "└───────────────────────────────┘"
echo ""
echo "█▓▒▒░░░INSTALLATION by Agung Developer░░░▒▒▓█"
echo ""
sleep 0.5

# --- FRAME RATE OPTIMIZATION ---
(
  settings put system display.refresh_rate 120
  settings put system max_refresh_rate 120
  settings put system min_refresh_rate 120
  settings put system user_refresh_rate 120
  settings put system display.low_framerate_limit 120
  settings put system disable_idle_fps true
  setprop debug.sf.perf_mode 1
  setprop debug.hwui.refresh_rate 120
) > /dev/null 2>&1 &

# --- FINAL STATUS ---
echo ""
echo "█▓▒▒░░░OPTIMIZATION STATUS by Agung Developer░░░▒▒▓█"
echo "FRAME RATE SET TO 120Hz [✓]"
echo "ALL SETTINGS APPLIED [✓]"
echo ""
echo "‼️ ENJOY SMOOTH PERFORMANCE WITH AGUNG DEVELOPER ‼️"
echo "█▓▒▒░░░THANKS FOR USING FRAME RATE CONTROLLER by Agung Developer░░░▒▒▓█"
echo ""

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'FRAME RATE OPTIMIZATION ACTIVATED by Agung Developer' --icon "$ICON_URL"
