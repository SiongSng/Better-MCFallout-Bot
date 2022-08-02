bash script/build_core_macos.sh

cd app
echo "[Info] Building the app"
flutter build macos --release

echo "[Info] Done"