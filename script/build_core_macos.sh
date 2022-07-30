cd core
echo "[Info] Building core typescript to javascript"
yarn build
echo "[Info] Building core to executable"
yarn pkg:macos