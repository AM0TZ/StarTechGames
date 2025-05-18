## License

This project is open-source under the [MIT License](LICENSE).

## Author

Created by *Amotz Holender-Tal*


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
│   ├── launcher_thumbnail.png
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
   (make sure to include the `nitz13D.pde` and the `data` folder. for a game thumbnail in the launcher - create a `launcher_thumbnail.png`)
2. use the shortcut `משחקים`, pointing to `launcher.vbs`, or use the `.vbs` file directly 
   (the `launcher.vbs` runs the `.pde` using the shared `/processing-java.exe`)
3. in the launcher windows Click a thumbnail to play the game!

---
