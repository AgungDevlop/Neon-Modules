#!/system/bin/sh
# 🎮 Game Mode - Optimasi performa game (by Agung Developer)

echo "🎮 Mengaktifkan mode game..."

(
# Aktivasi mode game
settings put system game_mode 1
setprop debug.game.perf_mode 1
setprop persist.sys.game_mode 1
settings put system game_driver_gpu_mode 1
settings put system game_driver_fps_limit 120
) > /dev/null 2>&1 &

echo "✅ Mode game diaktifkan untuk performa maksimal."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING GAME MODE ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Game Mode Activated.'