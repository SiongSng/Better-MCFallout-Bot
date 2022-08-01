bash script/build_core_macos.sh

cd app
echo "[Info] Building the app"
flutter build macos --release

cd ..
mkdir -p app/build/macos/Build/Products/Release/lib; mv core/out/better-mcfallout-bot $_/better-mcfallout-bot-core

echo "[Info] Done"