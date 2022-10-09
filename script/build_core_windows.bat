cd core
echo "[Info] Install dependencies"
yarn install && yarn build && yarn pkg:windows && cd .. && copy "core\out\better-mcfallout-bot-core.exe" "app\assets\better-mcfallout-bot-core.exe"