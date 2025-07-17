#!/system/bin/sh
# 📋 Process Manager - Mengatur proses latar (by Agung Developer)

echo "📋 Mengatur proses latar belakang..."

(
# Menghentikan proses latar yang tidak perlu
am kill-all
setprop persist.sys.process.manager 1
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
) > /dev/null 2>&1 &

echo "✅ Proses latar dioptimalkan untuk performa."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING PROCESS MANAGER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Processes Optimized.'