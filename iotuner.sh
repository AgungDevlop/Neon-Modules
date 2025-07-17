#!/system/bin/sh
# 💽 IO Tuner - Optimasi input/output (by Agung Developer)

echo "💽 Mengoptimalkan input/output..."

(
# Optimasi I/O
echo cfq > /sys/block/mmcblk0/queue/scheduler
echo 2048 > /sys/block/mmcblk0/queue/read_ahead_kb
setprop persist.sys.io.optimize 1
) > /dev/null 2>&1 &

echo "✅ I/O dioptimalkan untuk kecepatan baca/tulis."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING IO TUNER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: IO Optimized.'