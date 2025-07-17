#!/system/bin/sh
  # VIBRATION CONTROL by Agung Developer - Manage Vibration Settings
  # Watermark: © Agung Developer 2025
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎚️ Starting Vibration Control by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   🎚️  VIBRATION CONTROL by Agung Developer  🎚️"echo "   © Agung Developer 2025 - Vibration Master!"echo -e "\033[0m"
  (
    settings put system haptic_feedback_enabled 0
    echo 0 > /sys/class/timed_output/vibrator/enable
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 VIBRATION CONTROLLED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '🎚️ VIBRATION MANAGED by © Agung Developer 2025' --icon "$ICON_URL"