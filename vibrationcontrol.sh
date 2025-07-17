#!/system/bin/sh
# 📳 Vibration Control - Mengatur getaran (by Agung Developer)

echo "📳 Mengatur intensitas getaran..."

(
# Mengurangi intensitas getaran
echo 0 > /sys/class/leds/vibrator/brightness
setprop persist.sys.vibration 0
settings put system vibrate_on_touch 0
) > /dev/null 2>&1 &

echo "✅ Getaran dioptimalkan untuk penghematan daya."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING VIBRATION CONTROL ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Vibration Optimized.'