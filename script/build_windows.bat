bash script/build_core_windows.bat

cd app
echo "[Info] Building the app"
flutter build windows --release

cd ..
mkdir -p app/build/windows/runner/Release/lib; mv core/out/better-mcfallout-bot.exe $_/better-mcfallout-bot-core.exe

echo "[Info] Done"