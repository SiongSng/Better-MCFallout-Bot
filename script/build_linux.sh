bash script/build_core_linux.sh

cd app
echo "[Info] Building the app"
flutter build linux --release

echo "[Info] Copying the core to the app"
cd ..
mkdir -p app/build/linux/x64/release/bundle/lib
mv core/out/better-mcfallout-bot app/build/linux/x64/release/bundle/lib/better-mcfallout-bot-core

echo "[Info] Done"