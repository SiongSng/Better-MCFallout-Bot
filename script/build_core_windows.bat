@echo off

cd core
echo "[Info] Install dependencies"
call yarn install

echo "[Info] Building core to executable"
call yarn pkg:windows

echo "[Info] Copying the core to the app"
cd ..
copy "core\out\better-mcfallout-bot-core.exe" "app\assets\better-mcfallout-bot-core.exe"