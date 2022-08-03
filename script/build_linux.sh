bash script/build_core_linux.sh

cd app
echo "[Info] Building the app"
flutter build linux --release

echo "[Info] Done"