## License

Copyright © [2025] [Amotz Holender-Tal]

This software is licensed for personal, non-commercial use only.
Commercial use, government use, educational or institutional use, redistribution, and modification are prohibited.

## Author

Created by *Amotz Holender-Tal*

![image](https://github.com/user-attachments/assets/02ff3f88-64d8-45a9-8cd2-728b4ef95676)

# StarTechGames Launcher

**StarTechGames** is a Java-based launcher built with the [Processing](https://processing.org/) framework. It provides a graphical interface to browse and run student-made games from a shared `games` folder.

The launcher is designed for portability — it includes its own Processing and Java runtime, allowing it to run on any Windows machine without requiring external Java installation.

## Features

* 📁 Auto-detects games from a local `games` folder (each in its own subdirectory)
* 🎮 Displays game thumbnails and titles in a responsive grid
* 🖱️ Click-to-launch any game using `processing-java`
* 🔁 Reuses a shared Java runtime for all games
* 🧩 Automatically ensures required libraries (like Minim) are available to each game

## Folder Structure

```
StarTechGames/
├── launcher/             # The launcher Processing sketch
├── games/                # Subfolders for each student game
│   ├── studentGame.pde
│   ├── nitz13D.pde
│   ├── launcher_thumbnail.png      # create a screenshot of the game and save with this name - to be displayed as thumbnail in the launcher
├── processing/           # Bundled Processing and Java folders - to be downloaded independently 
│   ├── processing-java.exe
│   ├── java/
│   └── libraries/
```

## Requirements

- **Windows Operating System**
- **Java Runtime Environment (JRE)**  
  Download the Java bundle from [this link](https://github.com/processing/processing4/releases/download/processing-1297-4.3.4/processing-4.3.4-windows-x64.zip) and extract it into the `processing/java` directory.  
  > ***Note:** This is the last version of Processing that **does not** require installation and can run as a standalone application.*


## Usage

1. Place your `.pde` games into subfolders under the `games/` directory.  
   - Each game folder should include the `nitz13D.pde` file and a `data` folder.  
   - To display a thumbnail in the launcher, take a screenshot of the game screen and save it as `launcher_thumbnail.png` in the game's folder.

2. Use the desktop shortcut named `משחקים` (which points to `launcher.vbs`), or run `launcher.vbs` directly.  
   - This script launches the game using the shared `processing-java.exe`.

3. In the launcher window, click a game thumbnail to start playing!


## Known Issues

### 🚨 Files May Be Flagged After Download

When you download a `.vbs`, `.pde`, `.exe`, or similar file from the web or GitHub, Windows automatically attaches a hidden metadata tag called a **Zone.Identifier** (an Alternate Data Stream, or ADS).  
This tells the operating system and antivirus software that the file originated from the Internet and should be treated with caution.

### ✅ How to Check for This

1. **Right-click** the downloaded file and select **Properties**.
2. If you see a message at the bottom that says:  
`This file came from another computer and might be blocked to help protect this computer.`
— this confirms that the file is flagged due to its origin.

### 🛠️ How to Fix It

To remove the Internet zone warning:

- **Right-click** the file (e.g., `.vbs` or `.vbe`)
- Select **Properties**
- Click the **Unblock** checkbox (if available), then click **Apply**

Repeat this process for any additional files (e.g., `.vbe`) if needed.
