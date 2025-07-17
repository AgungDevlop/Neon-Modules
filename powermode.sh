#!/system/bin/sh
  # POWER MODE by Agung Developer - Adjust Power Settings
  # Watermark: © Agung Developer 2025
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '⚡ Starting Power Mode by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   ⚡  POWER MODE by Agung Developer  ⚡"echo "   © Agung Developer 2025 - Power Control!"echo -e "\033[0m"
  (
    settings put global powersaving_mode_enabled 0
    echo 1 > /sys/module/cpu_boost/parameters/input_boost_freq
    setprop debug.performance.profile 1
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 POWER MODE ACTIVATED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '⚡ POWER MODE ON by © Agung Developer 2025' --icon "$ICON_URL"