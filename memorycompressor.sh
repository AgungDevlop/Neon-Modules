#!/system/bin/sh
# 🗜️ Memory Compressor - Mengompresi memori (by Agung Developer)

echo "🗜️ Mengompresi memori untuk efisiensi..."

(
# Optimasi kompresi memori
echo 100 > /proc/sys/vm/swappiness
echo 1 > /proc/sys/vm/compact_unevictable_allowed
setprop persist.sys.memory.compress 1
) > /dev/null 2>&1 &

echo "✅ Memori dioptimalkan untuk efisiensi."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING MEMORY COMPRESSOR ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Memory Compressed.'