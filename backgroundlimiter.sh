#!/system/bin/sh
  # BACKGROUND LIMITER by Agung Developer - Limit Background Processes
  # Watermark: © Agung Developer 2025
  ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
  echo -e "\033[1;32m"cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '⏳ Starting Background Limit by © Agung Developer 2025' --icon "$ICON_URL"echo -e "\033[0m"
  echo -e "\033[1;36m"echo "   ⏳  BACKGROUND LIMITER by Agung Developer  ⏳"echo "   © Agung Developer 2025 - Background Control!"echo -e "\033[0m"
  (
    dumpsys deviceidle whitelist -$(cmd package list packages -3 | sed 's/package://g')
    echo 0 > /proc/sys/kernel/sched_rt_runtime_us
  ) > /dev/null 2>&1 &
  echo -e "\033[1;32m"echo "   🎉 BACKGROUND LIMITED [✓]"echo "   © Agung Developer 2025"echo -e "\033[0m"
  cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' '⏳ BACKGROUND MANAGED by © Agung Developer 2025' --icon "$ICON_URL"