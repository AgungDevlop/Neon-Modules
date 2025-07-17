#!/system/bin/sh
  # GAME MODE by Agung Developer - Optimize for Gaming
  # Watermark: © Agung Developer 2025
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎮 Starting Game Mode by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🎮  GAME MODE by Agung Developer  🎮"echo "   © Agung Developer 2025 - Game On!"echo -e "\033[0m"
  (
    setprop debug.performance.profile 1
    echo 0 > /sys/module/lowmemorykiller/parameters/enable_lmk
    settings put system max_refresh_rate 120
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 GAME MODE ACTIVATED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎮 GAME MODE ON by © Agung Developer 2025' --icon "$ICON_URL"