#!/system/bin/sh
# 🌐 Network Booster - Meningkatkan stabilitas jaringan (by Agung Developer)

echo "🌐 Mengoptimalkan koneksi jaringan..."

(
# Optimasi jaringan
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
setprop net.tcp.delack 0
setprop persist.sys.net.boost 1
settings put global wifi_scan_always_enabled 0
settings put global mobile_data_always_on 0
) > /dev/null 2>&1 &

echo "✅ Jaringan dioptimalkan untuk stabilitas dan kecepatan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING NETWORK BOOSTER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Network Optimized.'