bash script/build_core_macos.sh

cd app
echo "[Info] Building the app"
flutter build macos --release

echo "[Info] Copying the core to the app"
cd ..
mkdir -p app/build/macos/Build/Products/Release/lib
move core/out/better-mcfallout-bot app/build/macos/Build/Products/Release/lib/better-mcfallout-bot-core
ls app/build/macos/Build/Products/Release/lib

echo "[Info] Done"