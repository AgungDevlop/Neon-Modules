#!/system/bin/sh
# 🧹 Log Cleaner - Membersihkan log sistem (by Agung Developer)

echo "🧹 Membersihkan log sistem..."

(
# Membersihkan log
rm -rf /data/log/*
setprop persist.sys.log.clear 1
) > /dev/null 2>&1 &

echo "✅ Log sistem dibersihkan."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING LOG CLEANER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: Logs Cleared.'