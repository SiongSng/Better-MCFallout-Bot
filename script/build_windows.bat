bash script/build_core_windows.bat

cd app
echo "[Info] Building the app"
flutter build windows --release

cd ..
mkdir -p app/build/windows/runner/Release/lib
move core/out/better-mcfallout-bot app/build/windows/runner/Release/lib/better-mcfallout-bot-core

echo "[Info] Done"