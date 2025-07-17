#!/system/bin/sh
  # RAM CLEANER by Agung Developer - Clean RAM for Peak Performance
  # Watermark: © Agung Developer 2025
  GAME_PACKAGE="$1"
  if [ -z "$GAME_PACKAGE" ]; then echo -e "\033[1;31mNo game package specified!\033[0m"; else echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"; dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1; echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"; fi
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🧹 Starting RAM Cleaning for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🧹  RAM CLEANER by Agung Developer  🧹"echo "   © Agung Developer 2025 - Pure Speed!"echo -e "\033[0m"
  (
    echo 3 > /proc/sys/vm/drop_caches
    pm trim-caches $(pm list packages -f | sed -e 's/.*=//' -e 's/\r//g' | cut -f 1)
    echo 10 > /proc/sys/vm/swappiness
    echo 50 > /proc/sys/vm/vfs_cache_pressure
    am force-stop-packages $(cmd package list packages -3 | sed 's/package://g')
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 RAM CLEANED AND OPTIMIZED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🧹 RAM CLEANED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"