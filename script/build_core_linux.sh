cd core
echo "[Info] Install dependencies"
corepack enable
yarn install
echo "[Info] Building core typescript to javascript"
yarn build
echo "[Info] Building core to executable"
yarn pkg:linux

echo "[Info] Moving the core to the app"
cd ..
mv core/out/better-mcfallout-bot app/assets/better-mcfallout-bot-core