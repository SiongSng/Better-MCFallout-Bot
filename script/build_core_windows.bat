cd core
echo "[Info] Install dependencies"
corepack enable
yarn install
echo "[Info] Building core typescript to javascript"
yarn build
echo "[Info] Building core to executable"
yarn pkg:windows