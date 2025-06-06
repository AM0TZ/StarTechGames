## License

This project is open-source under the [MIT License](LICENSE).

## Author

Created by *Amotz Holender-Tal*

![image](https://github.com/user-attachments/assets/7372f1da-0bc7-487e-813f-33b2308ff29e)

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

* Windows OS
* No Java installation required (included in `processing/java`)

## Usage

1. Place your `.pde` games into subfolders under `games/`
   (make sure to include the `nitz13D.pde` and the `data` folder. for a game thumbnail in the launcher - take a screenshot of the game screen and add as `launcher_thumbnail.png` to game folder)
2. use the shortcut `משחקים`, pointing to `launcher.vbs`, or use the `.vbs` file directly 
   (the `launcher.vbs` runs the `.pde` using the shared `/processing-java.exe`)
3. in the launcher windows Click a thumbnail to play the game!


## Known Issues

🚨  When you download a .vbs (or .pde, .exe, etc.) from the web or GitHub, Windows attaches a hidden "Zone.Identifier" metadata to the file — called an Alternate Data Stream (ADS). 
This tells the system (and antivirus tools) that the file came from the Internet and should be treated with caution.

✅ How to Confirm This: Check for Zone.Identifier: 
Right-click the downloaded file → Properties. If you see a message at the bottom like:
        `This file came from another computer and might be blocked to help protect this computer.`
That confirms it's flagged due to its origin.

🛠️ How to Mitigate It: Remove the "Internet Zone" Mark by Right-clicking the .vbs → Properties → click Unblock (if visible) → Apply.
   do it for the .vbe if needed

