#!/system/bin/sh
# 🖼️ Display Tuner - Menyesuaikan refresh rate layar (by Agung Developer)

echo "🖼️ Mengoptimalkan pengaturan layar..."

(
# Optimasi refresh rate dan resolusi
settings put system display.refresh_rate 120
settings put system display_min_refresh_rate 120
setprop debug.hwui.refresh_rate 120
setprop debug.sf.perf_mode 1
) > /dev/null 2>&1 &

echo "✅ Layar dioptimalkan untuk performa visual."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING DISPLAY TUNER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Display Optimized.'