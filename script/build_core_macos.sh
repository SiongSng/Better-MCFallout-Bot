cd core
echo "[Info] Install dependencies"
corepack enable
yarn install
echo "[Info] Building core typescript to javascript"
yarn build
echo "[Info] Building core to executable"
yarn pkg:macos

echo "[Info] Copying the core to the app"
cd ..
cp core/out/better-mcfallout-bot-core app/assets/better-mcfallout-bot-core