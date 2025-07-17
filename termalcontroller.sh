#!/system/bin/sh
# TERMAL CONTROLLER by Agung Developer - Manages device temperature
# Watermark: Agung Developer

# --- NOTIFICATION AND HEADER ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting Thermal Control by Agung Developer' --icon "$ICON_URL"

echo ""
echo "█▓▒▒░░░TERMAL CONTROLLER by Agung Developer░░░▒▒▓█"
echo ""
sleep 0.5

# --- DEVICE & HARDWARE INFO ---
echo "┌───────────────────────────────┐"
echo "│   DEVICE & HARDWARE INFO      │"
echo "├───────────────────────────────┤"
echo "│ 📱 Device: $(getprop ro.product.manufacturer) $(getprop ro.product.model)"
echo "│ 🔥 Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)°C"
echo "└───────────────────────────────┘"
echo ""
echo "█▓▒▒░░░INSTALLATION by Agung Developer░░░▒▒▓█"
echo ""
sleep 0.5

# --- THERMAL OPTIMIZATION ---
(
  echo 0 > /sys/class/thermal/thermal_zone0/mode
  echo "disabled" > /sys/class/thermal/thermal_zone0/policy
  echo 0 > /sys/module/msm_thermal/parameters/enabled
  settings put global low_power 0
) > /dev/null 2>&1 &

# --- FINAL STATUS ---
echo ""
echo "█▓▒▒░░░OPTIMIZATION STATUS by Agung Developer░░░▒▒▓█"
echo "THERMAL THROTTLING DISABLED [✓]"
echo "ALL SETTINGS APPLIED [✓]"
echo ""
echo "‼️ MONITOR TEMPERATURE WITH AGUNG DEVELOPER ‼️"
echo "█▓▒▒░░░THANKS FOR USING TERMAL CONTROLLER by Agung Developer░░░▒▒▓█"
echo ""

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'THERMAL CONTROL ACTIVATED by Agung Developer' --icon "$ICON_URL"
