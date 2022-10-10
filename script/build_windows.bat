@echo off

call script/build_core_windows.bat

cd app
echo "[Info] Building the app"
flutter build windows --release

echo "[Info] Done"