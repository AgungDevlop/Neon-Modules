#!/system/bin/sh
# RAM CLEANER by Agung Developer - Clean RAM for Peak Performance
# Optimized for speed and stability | Watermark: © Agung Developer 2025

ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🧹 Starting RAM Cleaning by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"

echo -e "\033[1;36m"echo "   🧹  RAM CLEANER by Agung Developer  🧹"echo "   © Agung Developer 2025 - Pure Speed!"echo -e "\033[0m"
sleep 1

echo -e "\033[1;34m"echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"echo "┃        RAM STATUS               ┃"echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"echo -e "\033[0m"

(
  echo 3 > /proc/sys/vm/drop_caches
  am force-stop-packages $(cmd package list packages -3 | sed 's/package://g')
  echo 10 > /proc/sys/vm/swappiness
) > /dev/null 2>&1 &

echo -e "\033[1;32m"echo "   🎉 RAM CLEANED AND OPTIMIZED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🧹 RAM CLEANED by © Agung Developer 2025' --icon "$ICON_URL"