#!/system/bin/sh
# 💾 Storage Optimizer - Optimasi penyimpanan (by Agung Developer)

echo "💾 Mengoptimalkan penyimpanan..."

(
# Optimasi I/O storage
echo noop > /sys/block/mmcblk0/queue/scheduler
echo 0 > /sys/block/mmcblk0/queue/read_ahead_kb
setprop persist.sys.storage.optimize 1
sync
) > /dev/null 2>&1 &

echo "✅ Penyimpanan dioptimalkan untuk kecepatan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING STORAGE OPTIMIZER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Storage Optimized.'