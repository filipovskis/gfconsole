# gfconsole

A **user-friendly** developer console for **Garry's Mod**. 
Makes possible to relay **messages** and **errors** from a **server's console** to developers in-game, so they could develop without interrupting to check a server's control panel.

### 💡 Features
- Server console messages are relaying to the console
  - `print` is supported
  - `Msg` is supported
  - `MsgC` is supported
  - `PrintTable` is supported
- Errors are relaying to the console
- Realm switching
- Subscription system
- Filter system
- FPS and ping indicators
- Optimized message delivery
- The console can be moved or resized

### 🔨 Setup
1. Download this repository from the releases section.
2. Extract the file.
3. Place `gfconsole` folder into your server's `garrysmod/addons` folder.
4. Restart your server.
5. You're done.

#### (Optional) If you want error relaying
1. Download an appropriate DLL from [gm_luaerror](https://github.com/danielga/gm_luaerror)'s releases section (`gmsv_luaerror_win32` for example).
2. Place the DLL into your server's `garrysmod/lua/bin` folder (if there's no folder create one).
3. Be sure that `errors` extension in enabled in config.
4. You're done.

### 🤔 How to use
NOTE: You can enable the autocreation of the console by changing convar `gfconsole_autocreate`'s value to true
NOTE: You can enable the autosubscription to the console by changing convar `gfconsole_autosubcribe`'s value to true

1. Bind any button to `+gfconsole`
2. Hold the button to interact with the console
3. Press the "subscribe" button at the console's top

### 👀 Showcase
![Screenshot](https://i.imgur.com/dBec2Br.png)

### 🔗 Credits
- [thelastpenguin](https://github.com/thelastpenguin) - pON
