#!/system/bin/sh
# 🚀 Boot Optimizer - Optimasi proses booting (by Agung Developer)

echo "🚀 Mengoptimalkan proses booting..."

(
# Optimasi booting
setprop persist.sys.boot.optimize 1
echo 0 > /sys/module/boot/parameters/boot_time
settings put global boot_animation 0
) > /dev/null 2>&1 &

echo "✅ Proses booting dioptimalkan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING BOOT OPTIMIZER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Boot Optimized.'