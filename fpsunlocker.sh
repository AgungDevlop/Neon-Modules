#!/system/bin/sh
  # FPS UNLOCKER by Agung Developer - Unlock FPS Limits
  # Watermark: © Agung Developer 2025
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎯 Starting FPS Unlock by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🎯  FPS UNLOCKER by Agung Developer  🎯"echo "   © Agung Developer 2025 - FPS Freedom!"echo -e "\033[0m"
  (
    settings put system max_refresh_rate 144
    setprop debug.sf.high_fps_early_phase_offset_ns 1000000
    setprop debug.hwui.refresh_rate 144
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 FPS UNLOCKED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎯 FPS UNLOCKED by © Agung Developer 2025' --icon "$ICON_URL"