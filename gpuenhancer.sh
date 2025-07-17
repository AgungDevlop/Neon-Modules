#!/system/bin/sh
# GPU ENHANCER by Agung Developer - Max GPU Power
# Optimized for stunning graphics | Watermark: © Agung Developer 2025

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
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🎮 Starting GPU Boost for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"
echo -e "\033[0m"

# --- ASCII ART HEADER ---
echo -e "\033[1;36m"
echo "   🖥️  GPU ENHANCER by Agung Developer  🖥️"
echo "   © Agung Developer 2025 - Visual Mastery!"
echo -e "\033[0m"
sleep 1

# --- DEVICE & HARDWARE INFO ---
echo -e "\033[1;34m"
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃        GPU STATUS               ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"

# --- GPU OPTIMIZATION ---
(
  echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null
  echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on
  echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on
  echo 1 > /sys/class/kgsl/kgsl-3d0/force_pw_on
  setprop persist.sys.gpu_perf_mode 1
) > /dev/null 2>&1 &

# --- FINAL STATUS WITH STYLE ---
echo -e "\033[1;32m"
echo "   🎉 GPU MAXIMIZED [✓]"
echo "   © Agung Developer 2025"
echo -e "\033[0m"

cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' "🎮 GPU ENHANCED for $GAME_PACKAGE by © Agung Developer 2025" --icon "$ICON_URL"