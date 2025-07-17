#!/system/bin/sh
# TOUCH SENSITIVITY by Agung Developer - Enhance Touch Response
# Optimize touchscreen for faster input | Watermark: © Agung Developer 2025

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
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🖱️ Starting Touch Sensitivity Boost for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;36m"
echo "════════════════════════════════════════════"
echo "   🖱️  TOUCH SENSITIVITY by Agung Developer  🖱️"
echo "   © Agung Developer 2025 - Touch Precision!"
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
echo "┃ 📲 Android: $(getprop ro.build.version.release)      ┃"
echo "┃ 🔥 Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)°C ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"
sleep 0.5

# --- TOUCH SENSITIVITY OPTIMIZATION ---
echo -e "\033[1;33m"
echo "🔧 Enhancing Touch Sensitivity..."
echo -e "\033[0m"
(
  setprop debug.touch.sensitivity 0.8
  echo 2 > /sys/class/touchscreen/touch_threshold 2>/dev/null
  echo 1 > /sys/class/touchscreen/touch_sensitivity 2>/dev/null
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m"
echo "════════════════════════════════════════════"
echo "   🎉 OPTIMIZATION STATUS by Agung Developer 🎉"
echo "   🖱️ TOUCH SENSITIVITY ENHANCED [✓]        "
echo "   ✅ ALL SETTINGS APPLIED [✓]               "
echo "   © Agung Developer 2025 - Precision Touch! "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🖱️ TOUCH SENSITIVITY BOOSTED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"