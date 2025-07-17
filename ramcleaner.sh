#!/system/bin/sh
# 🧹 RAM Cleaner - Membersihkan RAM untuk kecepatan sistem (by Agung Developer)

echo "🧹 Membersihkan RAM..."

(
# Membersihkan cache dan memori
sync
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/vm/swappiness
setprop persist.sys.lowmemorykiller 0
am kill-all
) > /dev/null 2>&1 &

echo "✅ RAM dibersihkan untuk meningkatkan kecepatan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING RAM CLEANER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: RAM Cleaned.'