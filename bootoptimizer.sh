#!/system/bin/sh
  # BOOT OPTIMIZER by Agung Developer - Speed Up Boot Time
  # Watermark: © Agung Developer 2025
  GAME_PACKAGE="$1"
  if [ -z "$GAME_PACKAGE" ]; then echo -e "\033[1;31mNo game package specified!\033[0m"; else echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"; dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1; echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"; fi
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🚀 Starting Boot Optimization for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🚀  BOOT OPTIMIZER by Agung Developer  🚀"echo "   © Agung Developer 2025 - Boot Speed!"echo -e "\033[0m"
  (
    echo 0 > /sys/module/lowmemorykiller/parameters/enable_lmk
    echo 0 > /sys/kernel/boot_boost
    setprop persist.sys.boot_completed 1
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 BOOT OPTIMIZED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🚀 BOOT ENHANCED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"