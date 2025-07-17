#!/system/bin/sh
# 🛠️ Kernel Tweaker - Menyesuaikan parameter kernel (by Agung Developer)

echo "🛠️ Mengoptimalkan parameter kernel..."

(
# Optimasi kernel
echo 0 > /proc/sys/kernel/sched_min_granularity_ns
echo 1 > /proc/sys/kernel/sched_tunable_scaling
setprop persist.sys.kernel.optimize 1
) > /dev/null 2>&1 &

echo "✅ Kernel dioptimalkan untuk performa maksimal."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING KERNEL TWEAKER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Kernel Optimized.'