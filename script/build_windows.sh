bash script/build_core_windows.sh

cd app
echo "[Info] Building the app"
flutter build windows --release

cd ..
mkdir -p app/build/windows/runner/Release/lib; mv core/out/better-mcfallout-bot $_/better-mcfallout-bot-core

echo "[Info] Done"