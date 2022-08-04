cd core
echo "[Info] Install dependencies"
corepack enable
yarn install
echo "[Info] Building core typescript to javascript"
yarn build
echo "[Info] Building core to executable"
yarn pkg:windows

echo "[Info] Copying the core to the app"
cd ..
copy core/out/better-mcfallout-bot-core.exe app/assets/better-mcfallout-bot-core.exe