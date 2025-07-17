#!/system/bin/sh
# CPU OPTIMIZER by Agung Developer - Max CPU Performance
# Optimized for efficiency and power | Watermark: © Agung Developer 2025

# --- CHECK GAME PACKAGE ---
GAME_PACKAGE="$1"
if [ -z "$GAME_PACKAGE" ]; then
  echo -e "\033[1;31mNo game package specified! Using default optimizations.\033[0m"
else
  echo -e "\033[1;32mOptimizing for game: $GAME_PACKAGE\033[0m"
  dumpsys deviceidle whitelist +"$GAME_PACKAGE" > /dev/null 2>&1
  echo "[✔] $GAME_PACKAGE optimized by Agung Developer!"
fi

# --- STYLISH NOTIFICATION ---
ICON_URL="https://png.pngtree.com/recommend-works/png-clipart/20250321/ourmid/pngtree-green-check-mark-icon-png-image_15808519.png"
echo -e "\033[1;32m"
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "💪 Starting CPU Boost for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;36m"
echo "   🛠️  CPU OPTIMIZER by Agung Developer  🛠️"
echo "   © Agung Developer 2025 - Power Unleashed!"
echo -e "\033[0m"
sleep 1

# --- DEVICE & HARDWARE INFO ---
echo -e "\033[1;34m"
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃        CPU STATUS               ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"

# --- CPU OPTIMIZATION ---
(
  for cpu_gov_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do [ -f "$cpu_gov_path" ] && echo "performance" > "$cpu_gov_path"; done
  for cpu_max_freq_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do [ -f "$cpu_max_freq_path" ] && cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq > "$cpu_max_freq_path"; done
  setprop debug.performance.profile 1
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m"
echo "   🎉 CPU SET TO MAX PERFORMANCE [✓]"
echo "   © Agung Developer 2025"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "💪 CPU OPTIMIZED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"