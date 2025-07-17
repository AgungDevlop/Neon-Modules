#!/system/bin/sh
# 📍 Sensor Optimizer - Mengoptimalkan sensor (by Agung Developer)

echo "📍 Mengoptimalkan sensor perangkat..."

(
# Optimasi sensor
setprop persist.sys.sensor.optimize 1
echo 0 > /sys/class/sensors/proximity_sensor/enable
echo 0 > /sys/class/sensors/light_sensor/enable
) > /dev/null 2>&1 &

echo "✅ Sensor dioptimalkan untuk efisiensi."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING SENSOR OPTIMIZER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Sensors Optimized.'