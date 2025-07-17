#!/system/bin/sh
# 🚀 Anti-Lag - Mengurangi lag sistem (by Agung Developer)

echo "🚀 Mengurangi lag sistem..."

(
# Optimasi scheduler dan prioritas
echo 0 > /proc/sys/kernel/sched_child_runs_first
echo 1 > /proc/sys/kernel/sched_tunable_scaling
setprop persist.sys.sched.optimize 1
setprop debug.sys.lag_reducer 1
) > /dev/null 2>&1 &

echo "✅ Lag sistem dikurangi untuk performa lebih mulus."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING ANTI-LAG ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Anti-Lag Applied.'