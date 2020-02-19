import java.util.*;

PlayerGo player1;
PlayerGo player2;
color board = color(180, 140, 30);
int growRate = 2;

int[] gameState;
int gameWidth;
int gameHeight;
int ratio = 10;

void setup ()
{
  background(board);
  ellipseMode(CORNER);
  
  size(800, 800, P3D);
  gameWidth = width/ratio;
  gameHeight = height/ratio;
  gameState = new int[gameWidth * gameHeight];
  Arrays.fill(gameState, board);
  
  player1 = new PlayerGo(color(255, 255, 240));
  player2 = new PlayerGo(color(0, 0, 16));
  mouseX = width/2;
  mouseY = height/2;
}

void draw ()
{
  player1.spill(mouseX/ratio, mouseY/ratio, growRate);
  player2.spill((int) (width/2 + cos((float)millis()/1000)*height/4)/ratio, (int) (height/2 + sin((float)millis()/1000)*height/4)/ratio, growRate);
  
  background(board);
  for (int i = 0; i < gameState.length; i++) {
    fill(gameState[i]);
    stroke(gameState[i]);
    int x = (i % gameWidth) * ratio;
    int y = (i / gameWidth) * ratio;
    //ellipse(x, y, ratio, ratio);
    rect(x, y, ratio, ratio);
    //quad(x + ratio/2, y, x + ratio, y + ratio/2, x + ratio/2, y + ratio, x, y + ratio/2);
    //if (i % gameWidth != gameWidth - 1) {
    //  if (gameState[i] == gameState[i+1]) {
    //    rect(x + ratio/2, y, ratio, ratio);
    //  }
    //}
    //if (i / gameWidth != gameHeight - 1) {
    //  if (gameState[i] == gameState[i+gameWidth]) {
    //    rect(x, y + ratio/2, ratio, ratio);
    //  }
    //}
  }
  
  if (player2.boundary.size() == 0) {
    noLoop();
    int w = 0;
    int b = 0;
    int u = 0;
    for (color c : gameState) {
      if (c == player1.flag) {w++;};
      if (c == player2.flag) {b++;};
      if (c == board) {u++;};
    }
    println("White Territory: " + (w + u));
    println("Black Territory: " + b);
    save("image" + (int)random(10000) + ".png");
  }
  
  //if (millis() > 5000) {
  //  noLoop();
  //  for (int p : player1.boundary) {
  //    pixels[p] = color(255, 0, 0);
  //  }
  //  updatePixels();
  //}
}
