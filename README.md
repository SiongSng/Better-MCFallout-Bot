# 更好的 Minecraft 廢土伺服器機器人

## 📚 介紹
這是個具有許多功能的廢土機器人，且完全**免費**與**開源**  
另一大特色就是具有容易操作的界面，而不是傳統的小黑窗，讓任何人都能夠輕鬆使用~

詳細功能請看 [這裡](#-功能)  
祝您使用愉快！

## [立即下載](#-下載)   

![image](https://user-images.githubusercontent.com/48402225/182155275-dc162aae-85ca-44a4-80d6-cef10a9bb55b.png)

## 🎮 下載
本軟體支援 Windows、Linux、macOS 作業系統，另外僅支援 64 位元的電腦。

[前我前往下載頁面](https://github.com/SiongSng/Better-MCFallout-Bot/releases/latest)

在下方的 `Assets` 欄位會看到檔案，請選擇對應您電腦的作業系統進行下載。  

![image](https://user-images.githubusercontent.com/48402225/182160712-9317bdf4-b406-4414-834b-1aeca5f06905.png)

### 如何使用
#### Windows
請先下載後，解壓縮檔案，接著執行 `better_mcfallout_bot.exe` 即可
#### Linux 
請先下載後，解壓縮檔案，接著執行 `better_mcfallout_bot` 即可

#### macOS
請先下載後檔案後並安裝，再去執行  
第一次執行時若出現 「Apple 無法檢查是否包含惡意軟體」等內容，屬於正常現象，因為沒使用 Apple 開發者帳號簽署 (Apple 開發者帳號蠻貴的)，請開啟「系統偏好設定」，進入「安全性與隱私權」類別，選擇強制開啟

## 🎨 功能
### ***自動刷突襲塔***
自動攻擊突襲塔的怪物，獲得滿滿的綠寶石 💵💵💵 

### 自動掛機
對就是掛機，看似很一般的功能，但不用開啟麥塊本體就可以輕鬆掛物資。  
~~雖然我不是數學家，但這聽起來還不錯對吧~~
### 自動飲食
自動飲食，肉、蔬菜、湯都支援，可以防止餓死 (腐肉是黑名單)

### 自動丟棄物品
自動丟棄不重要的物品，保留重要物品，像是武器、不死圖騰、食物、裝備，在刷突襲塔的時候很有用

### 自動重新連線
自動重新連線伺服器，如果突然斷線或者廢土伺服器當機，會每 30 秒自動重新連線一次，若失敗超過 10 次則自動暫停

### 多重開啟
同時啟動多個不同帳號的機器人，達成效益最大化！

## 🪟 截圖
![image](https://user-images.githubusercontent.com/48402225/182106836-05185041-ecea-424f-833c-512fe81abd4a.png)
![image](https://user-images.githubusercontent.com/48402225/182161060-941173f2-8147-4a29-aee6-b85e9ad03dae.png)

## ⚙️ 開發
注意：這是給開發者看的，如果您是使用者請看 [這裡](#-下載)

首先請先安裝 [Flutter SDK](https://docs.flutter.dev/get-started/install) 與 [Node.js](https://nodejs.org/download).

### VSCode
另外請安裝 [Flutter 的擴充套件](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)  
接著切換到執行的分頁並點擊小綠旗稍等一下就可以囉~  

![image](https://user-images.githubusercontent.com/48402225/182102401-d76f2745-c81b-458c-99cb-4999c7c9ee9d.png)

### CLI
並執行以下指令，稍等幾分鐘應該就會跳出畫面

Windows
```shell
script/dev_windows.bat
```

Linux
```bash
bash script/dev_linux.sh
```

macOS
```shell
bash script/dev_macos.sh
```

### Technologies
[Flutter](https://flutter.dev)  
[Dart](https://dart.dev)  
[Typescript](https://www.typescriptlang.org)  
Javascript  
[Node.js](https://nodejs.org)  
[Mineflayer](https://github.com/PrismarineJS/mineflayer)

## 免責聲明
本程式僅會回傳崩潰資訊，方便修復 Bug 並提供更好的體驗，不包含任何個人資料與帳號  
若是擔心安全問題可以自行從程式原始碼編譯，如果還是不放心的話就不要用吧