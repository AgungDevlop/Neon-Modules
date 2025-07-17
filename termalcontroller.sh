#!/system/bin/sh
# 🌡️ Termal Controller - Mengatur suhu perangkat (by Agung Developer)

echo "🌡️ Mengoptimalkan pengaturan suhu perangkat..."

(
# Mengatur thermal throttling
echo 0 > /sys/module/thermal/parameters/throttle_enable
echo 0 > /sys/class/thermal/thermal_zone0/trip_point_0_temp
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 0 > /sys/class/thermal/thermal_zone0/sustainable_power
echo 0 > /sys/module/thermal/parameters/thermal_throttle_limit
setprop persist.thermal.throttling 0
setprop debug.thermal.limit_fps 0
settings put system thermal_limit_refresh_rate 120
) > /dev/null 2>&1 &

echo "✅ Suhu perangkat dioptimalkan untuk mencegah overheating."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING TERMAL CONTROLLER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Thermal Optimized.'