#!/system/bin/sh
  # CACHE CLEARER by Agung Developer - Clear System Cache
  # Watermark: © Agung Developer 2025
  GAME_PACKAGE="$1"
  if [ -z "$GAME_PACKAGE" ]; then echo -e "\033[1;31mNo game package specified!\033[0m"; else echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"; dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1; echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"; fi
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🧹 Starting Cache Cleaning for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🧹  CACHE CLEARER by Agung Developer  🧹"echo "   © Agung Developer 2025 - Clean Power!"echo -e "\033[0m"
  (
    pm trim-caches $(pm list packages -f | sed -e 's/.*=//' -e 's/\r//g' | cut -f 1)
    echo 1 > /proc/sys/vm/drop_caches
    echo 2 > /proc/sys/vm/drop_caches
    echo 3 > /proc/sys/vm/drop_caches
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 CACHE CLEARED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🧹 CACHE CLEANED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"