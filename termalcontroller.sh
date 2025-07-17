#!/system/bin/sh
# TERMAL CONTROLLER by Agung Developer - Master Thermal Management
# Optimized for heat control | Watermark: © Agung Developer 2025

# --- STYLISH NOTIFICATION ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;35m" # Purple text
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '❄️ Starting Thermal Mastery by © Agung Developer 2025' --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;35m" # Purple text
echo "════════════════════════════════════════════"
echo "   🌡️  TERMAL CONTROLLER by Agung Developer  🌡️"
echo "   © Agung Developer 2025 - Cool Precision!  "
echo "════════════════════════════════════════════"
echo -e "\033[0m"
sleep 1

# --- DEVICE & HARDWARE INFO ---
echo -e "\033[1;34m" # Blue text
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃        THERMAL STATUS REPORT            ┃"
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
echo "┃ 📱 Device: $(getprop ro.product.manufacturer) $(getprop ro.product.model)    ┃"
echo "┃ 🔥 Current Temp: $(cat /sys/class/thermal/thermal_zone0/temp)°C ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"
sleep 0.5

# --- ADVANCED THERMAL OPTIMIZATION ---
echo -e "\033[1;33m" # Yellow text
echo "🔧 Activating Thermal Control..."
echo -e "\033[0m"
(
  echo 0 > /sys/class/thermal/thermal_zone0/mode
  echo "disabled" > /sys/class/thermal/thermal_zone0/policy
  echo 0 > /sys/module/msm_thermal/parameters/enabled
  echo 0 > /sys/devices/system/cpu/cpufreq/conservative/up_threshold
  settings put global low_power 0
  echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m" # Green text
echo "════════════════════════════════════════════"
echo "   🎉 OPTIMIZATION STATUS by Agung Developer 🎉"
echo "   ❄️ THERMAL THROTTLING DISABLED [✓]       "
echo "   ✅ ALL SETTINGS APPLIED [✓]               "
echo "   © Agung Developer 2025 - Stay Cool!      "
echo "   ⚠️ MONITOR TEMPERATURE REGULARLY        "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '❄️ THERMAL CONTROL ACTIVATED by © Agung Developer 2025' --icon "$ICON_URL"
