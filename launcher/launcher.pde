// v1.1

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.io.InputStreamReader;
import java.io.BufferedReader;

PFont font;
PImage logo;

String sharedJavaPath;
String processingJavaPath;
String gamesFolderPath;
String basePath;
String sketchbook;
String launcherTitle;

GameItem[] gameItems;
int hoveredIndex = -1;

void setup() {
  size(1200, 900);
  font = createFont("Play-Regular.ttf", 24);
  textFont(font);
  logo = loadImage("StarTech_LOGO.png");
  
  basePath = sketchPath();
  sharedJavaPath = basePath + "\\..\\processing\\java";
  processingJavaPath = basePath + "\\..\\processing\\processing-java.exe";
  gamesFolderPath = basePath + "\\..\\games";
  sketchbook = basePath + "\\..\\processing";

  launcherTitle = new File(basePath).getParentFile().getName();

  gameItems = loadGameItems();
  ensureMinimJarsInGameFolders();
  
}

void draw() {
  background(30);
  image(logo, (width - logo.width) / 2.0f, 20);  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text(launcherTitle, width / 2, 160);

  if (gameItems.length == 0) {
    fill(255, 100, 100);
    text("No games found.", width / 2, height / 2);
    return;
  }

  int cols = 5;
  int thumbSize = 150;
  int margin = 40;
  int startX = (width - (cols * thumbSize + (cols - 1) * margin)) / 2;
  int startY = 200;

  textSize(18);
  hoveredIndex = -1;

  for (int i = 0; i < gameItems.length; i++) {
    int col = i % cols;
    int row = i / cols;
    int x = startX + col * (thumbSize + margin);
    int y = startY + row * (thumbSize + margin + 30);

    GameItem game = gameItems[i];
    game.x = x;
    game.y = y;
    game.w = thumbSize;
    game.h = thumbSize;

    // Draw background box
    fill(50);
    noStroke();
    rect(x, y, thumbSize, thumbSize);

    // Draw thumbnail scaled proportionally inside square
    if (game.thumbnail != null) {
      float imgW = game.thumbnail.width;
      float imgH = game.thumbnail.height;
      float scale = min(thumbSize / imgW, thumbSize / imgH);

      float imgDrawW = imgW * scale;
      float imgDrawH = imgH * scale;

      float imgX = x + (thumbSize - imgDrawW) / 2;
      float imgY = y + (thumbSize - imgDrawH) / 2;

      image(game.thumbnail, imgX, imgY, imgDrawW, imgDrawH);
    }

    // Highlight if hovered
    if (mouseX >= x && mouseX <= x + thumbSize && mouseY >= y && mouseY <= y + thumbSize) {
      hoveredIndex = i;
      stroke(255, 255, 0);
      noFill();
      strokeWeight(4);
      rect(x, y, thumbSize, thumbSize);
      strokeWeight(1);
      noStroke();
    }

    // Draw label
    fill(255);
    textAlign(CENTER);
    text(game.name, x + thumbSize / 2, y + thumbSize + 18);
  }
    // Draw credit
    fill(150);
    textSize(16);
    text("Amotz Holender-Tal ©2025", width / 2, height - 30);
  }


void mousePressed() {
  if (hoveredIndex >= 0 && hoveredIndex < gameItems.length) {
    launchGame(gameItems[hoveredIndex]);
  }
}

GameItem[] loadGameItems() {
  File baseDir = new File(gamesFolderPath);
  if (!baseDir.exists() || !baseDir.isDirectory()) return new GameItem[0];

  File[] folders = baseDir.listFiles();
  ArrayList<GameItem> items = new ArrayList<GameItem>();

  for (File f : folders) {
    if (f.isDirectory()) {
      File[] contents = f.listFiles();
      if (contents == null) continue;

      File mainPde = null;
      for (File c : contents) {
        if (c.getName().endsWith(".pde")) {
          mainPde = c;
          break;
        }
      }

      if (mainPde != null) {
        PImage thumbnail = null;
        File thumbFile = new File(f, "launcher_thumbnail.png");
        if (thumbFile.exists()) {
          thumbnail = loadImage(thumbFile.getAbsolutePath());
        }

        items.add(new GameItem(f.getName(), f.getAbsolutePath(), thumbnail));
      }
    }
  }

  return items.toArray(new GameItem[0]);
}

class GameItem {
  String name;
  String path;
  PImage thumbnail;
  int x, y, w, h;

  GameItem(String name, String path, PImage thumbnail) {
    this.name = name;
    this.path = path;
    this.thumbnail = thumbnail;
  }
}

void ensureMinimJarsInGameFolders() {
  File minimLib = new File(basePath + "\\..\\processing\\libraries\\minim\\library");
  if (!minimLib.exists() || !minimLib.isDirectory()) return;

  File[] jars = minimLib.listFiles();
  if (jars == null) return;

  for (GameItem game : gameItems) {
    File codeFolder = new File(game.path, "code");
    if (!codeFolder.exists()) {
      codeFolder.mkdirs();
    }

    for (File jar : jars) {
      if (jar.getName().endsWith(".jar")) {
        File destJar = new File(codeFolder, jar.getName());
        if (!destJar.exists()) {
          try {
            java.nio.file.Files.copy(
              jar.toPath(),
              destJar.toPath(),
              java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );
            println("Copied " + jar.getName() + " to " + game.name);
          } catch (IOException ex) {
            println("Failed to copy: " + jar.getName());
            ex.printStackTrace();
          }
        }
      }
    }
  }
}


void launchGame(GameItem game) {
  ArrayList<String> command = new ArrayList<String>();
  command.add(processingJavaPath);                       // Path to processing-java.exe
  command.add("--sketch=" + game.path);                  // Path to the game folder
  command.add("--run");                                  // Run the sketch
  command.add("--java=" + sharedJavaPath);               // Path to the shared Java folder
  //command.add("--sketchbook=" + sketchbook);             // Set sketchbook for libraries

  println("Launching: " + String.join(" ", command));

  ProcessBuilder builder = new ProcessBuilder(command);
  builder.directory(new File(game.path));                // Set working directory
  builder.redirectErrorStream(true);                     // Merge stdout and stderr

  try {
    Process process = builder.start();

    // Print output from the launched process (for debugging)
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) {
      println(line);
    }

    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
