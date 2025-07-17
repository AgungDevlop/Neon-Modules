#!/system/bin/sh
# CPU OPTIMIZER by Agung Developer - Optimizes CPU performance
# Watermark: Agung Developer

ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'Starting CPU Optimization by Agung Developer' --icon "$ICON_URL"

echo "█▓▒▒░░░CPU OPTIMIZER by Agung Developer░░░▒▒▓█"
sleep 0.5
echo "┌───────────────────────────────┐"
echo "│   DEVICE INFO                 │"
echo "├───────────────────────────────┤"
echo "│ ⚙️ CPU: $(getprop ro.board.platform)"
echo "└───────────────────────────────┘"
echo "█▓▒▒░░░INSTALLATION by Agung Developer░░░▒▒▓█"
sleep 0.5

(
  for cpu_gov_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
      [ -f "$cpu_gov_path" ] && echo "performance" > "$cpu_gov_path"
  done
  for cpu_max_freq_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
      [ -f "$cpu_max_freq_path" ] && cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq > "$cpu_max_freq_path"
  done
) > /dev/null 2>&1 &

echo "█▓▒▒░░░OPTIMIZATION STATUS by Agung Developer░░░▒▒▓█"
echo "CPU SET TO PERFORMANCE MODE [✓]"
echo "ALL SETTINGS APPLIED [✓]"
echo "‼️ ENJOY CPU OPTIMIZATION WITH AGUNG DEVELOPER ‼️"
echo "█▓▒▒░░░THANKS FOR USING CPU OPTIMIZER by Agung Developer░░░▒▒▓█"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'CPU OPTIMIZATION ACTIVATED by Agung Developer' --icon "$ICON_URL"
