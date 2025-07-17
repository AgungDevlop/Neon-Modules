#!/system/bin/sh
# 🔓 FPS Unlocker - Membuka batasan FPS (by Agung Developer)

echo "🔓 Membuka batasan FPS..."

(
# Membuka batasan FPS
setprop debug.sys.fps_unlock_allowed 120
settings put system NV_FPSLIMIT 120
settings put system fps_limit 120
setprop debug.sys.display.max_fps 120
) > /dev/null 2>&1 &

echo "✅ Batasan FPS dibuka untuk pengalaman lebih halus."
echo ""
sleep 0.5
echo "DEV: Agung Developer"
echo ""
sleep 0.5
echo "THANKS FOR USING"
echo ""
sleep 0.5
echo "█▓▒▒░░░THANKS FOR USING FPS UNLOCKER ░░░▒▒▓█"
echo ""
cmd notification post -S bigtext -t 'FPS INJECTOR' 'Tag' 'SUCCESS: FPS Unlocked.'