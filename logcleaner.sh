#!/system/bin/sh
# LOG CLEANER by Agung Developer - Clear System Logs
# Optimize performance by removing logs | Watermark: © Agung Developer 2025

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
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🗑️ Starting Log Cleaning for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;36m"
echo "════════════════════════════════════════════"
echo "   🗑️  LOG CLEANER by Agung Developer  🗑️"
echo "   © Agung Developer 2025 - Log Free!"
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

# --- LOG CLEANING ---
echo -e "\033[1;33m"
echo "🔧 Clearing System Logs..."
echo -e "\033[0m"
(
  logcat -c
  dmesg -c
  rm -rf /data/system/dropbox/* 2>/dev/null
  rm -rf /data/log/* 2>/dev/null
  mkdir -p /data/system/dropbox
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m"
echo "════════════════════════════════════════════"
echo "   🎉 OPTIMIZATION STATUS by Agung Developer 🎉"
echo "   🗑️ SYSTEM LOGS CLEARED [✓]              "
echo "   ✅ ALL SETTINGS APPLIED [✓]               "
echo "   © Agung Developer 2025 - Clean & Fast!   "
echo "════════════════════════════════════════════"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🗑️ LOGS CLEARED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"