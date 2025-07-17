#!/system/bin/sh
# 🖱️ Touch Sensitivity - Menyesuaikan sensitivitas layar sentuh (by Agung Developer)

echo "🖱️ Mengoptimalkan sensitivitas layar sentuh..."

(
# Optimasi sensitivitas sentuh
setprop persist.sys.touch.sensitivity 1
echo 1 > /sys/class/touchscreen/touch/boost
settings put system touch_sensitivity 1
) > /dev/null 2>&1 &

echo "✅ Sensitivitas layar sentuh dioptimalkan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING TOUCH SENSITIVITY ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Touch Sensitivity Optimized.'