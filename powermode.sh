#!/system/bin/sh
# ⚡ Power Mode - Menyesuaikan mode daya (by Agung Developer)

echo "⚡ Mengatur mode daya untuk performa..."

(
# Mengatur mode performa tinggi
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
setprop persist.sys.power.mode performance
settings put global power_mode 1
) > /dev/null 2>&1 &

echo "✅ Mode daya diatur untuk performa tinggi."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING POWER MODE ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Power Mode Activated.'