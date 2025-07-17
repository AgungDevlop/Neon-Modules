#!/system/bin/sh
  # IO TUNER by Agung Developer - Optimize I/O Performance
  # Watermark: © Agung Developer 2025
  GAME_PACKAGE="$1"
  if [ -z "$GAME_PACKAGE" ]; then echo -e "\033[1;31mNo game package specified!\033[0m"; else echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"; dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1; echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"; fi
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "💾 Starting I/O Tuning for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   💾  IO TUNER by Agung Developer  💾"echo "   © Agung Developer 2025 - I/O Master!"echo -e "\033[0m"
  (
    echo deadline > /sys/block/mmcblk0/queue/scheduler
    echo 0 > /sys/block/mmcblk0/queue/read_ahead_kb
    echo 1 > /sys/block/mmcblk0/queue/nr_requests
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 I/O OPTIMIZED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "💾 I/O TUNED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"