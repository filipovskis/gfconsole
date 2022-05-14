# gfconsole
![Test](https://img.shields.io/github/license/tochnonement/gfconsole)

A **user-friendly** developer console for **Garry's Mod**. 
Makes possible to relay **messages** and **errors** from a **server's console** to developers in-game, so they could develop without need of interrupting to check a server's control panel.

### 💡 Features
- All messages that come to the original game console and to the server console are relaying to this console
- Errors are relaying to the console
- Realm switching (client/server/both)
- Subscription system
- Filter system
- Average ping and framerate indicators
- Optimized message delivery
- Frame customization (size, position, font and etc.)
- Vectors and Angles being parsed in the console, so you could easily copy them
- Simple to use

### 🔨 Setup
1. Download [the latest release](https://github.com/tochnonement/gfconsole/releases) from the releases section.
2. Extract the file.
3. Place `gfconsole` folder into your server's `garrysmod/addons` folder.
4. Restart your server.
5. You're done.

#### (Optional) If you want error relaying
1. Download the [gm_luaerror](https://github.com/danielga/gm_luaerror) module for your server's OS from the releases section (`gmsv_luaerror_win32.dll` for example).
2. Place the downloaded dll into your server's `garrysmod/lua/bin` folder (if there is no folder just create one).
3. Be sure that `errors` extension is enabled in config.
4. You're done.

### 🤔 How To Use
**NOTE:**
You can configure console up to your preferences, just type `gfconsole_settings` in the game console.

1. Bind any button to `+gfconsole`.
2. Hold the button to interact with the console.
3. Press the "Subscribe" button at the console's top.

### 👀 Showcase
![Console](https://i.imgur.com/dQ3aYu3.png)
![Settings](https://i.imgur.com/fDgJ20H.png)

### 🔗 Credits
- [thelastpenguin](https://github.com/thelastpenguin) - pON