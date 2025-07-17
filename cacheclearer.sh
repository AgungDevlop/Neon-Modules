#!/system/bin/sh
# 🧹 Cache Clearer - Membersihkan cache sistem (by Agung Developer)

echo "🧹 Membersihkan cache sistem..."

(
# Membersihkan cache
sync
echo 3 > /proc/sys/vm/drop_caches
setprop persist.sys.cache.clear 1
) > /dev/null 2>&1 &

echo "✅ Cache sistem dibersihkan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING CACHE CLEARER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Cache Cleared.'