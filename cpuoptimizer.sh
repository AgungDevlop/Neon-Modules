#!/system/bin/sh
# ⚙️ CPU Optimizer - Optimasi performa CPU (by Agung Developer)

echo "⚙️ Mengoptimalkan penggunaan CPU..."

(
# Mengatur governor CPU untuk performa
for cpu in /sys/devices/system/cpu/cpu*/cpufreq; do
    echo performance > $cpu/scaling_governor
    echo 0 > $cpu/scaling_min_freq
    echo 9999999 > $cpu/scaling_max_freq
done
setprop debug.cpu.perf_mode 1
setprop persist.sys.cpu.boost 1
echo 0 > /sys/module/cpu_boost/parameters/input_boost_ms
) > /dev/null 2>&1 &

echo "✅ CPU dioptimalkan untuk performa dan efisiensi."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING CPU OPTIMIZER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: CPU Optimized.'