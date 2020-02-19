import java.util.*;

int midpic = 0;

PlayerGo player1;
PlayerGo player2;
color board = color(180, 140, 30);
int growRate = 100;
int computerX;
int computerY;
int playerX;
int playerY;
float speed = 0.1;

void setup ()
{
  background(board);
  size(960, 720);
  loadPixels();
  
  player1 = new PlayerGo(color(255, 255, 224));
  player2 = new PlayerGo(color(0, 0, 32));
  mouseX = playerX = width/4;
  mouseY = playerY = height/2;
  computerX = width/4*3;
  computerY = height/2;
}

void draw ()
{
  computerX += (mouseX - computerX) * speed/2;
  computerY += (mouseY - computerY) * speed/2;
  playerX += (mouseX - playerX) * speed;
  playerY += (mouseY - playerY) * speed;
  
  for (int i = 0; i < growRate; i++) {
    //player1.spill(playerX, playerY, 1);
    player1.spill(mouseX, mouseY, 1);
    player2.spill((int) (width/2 + cos((float) millis()/1000)*height/4), (int) (height/2 + sin((float) millis()/1000)*height/4), 1);
    //player2.spill(computerX, computerY, 1);
  }
  updatePixels();
  
  if (player2.boundary.size() == 0 && player1.boundary.size() == 0) {
    noLoop();
    int w = 0;
    int b = 0;
    int u = 0;
    for (color c : pixels) {
      if (c == player1.flag) {w++;};
      if (c == player2.flag) {b++;};
      if (c == board) {u++;};
    }
    println("White Territory: " + (w + u));
    println("Black Territory: " + b);
    //save("image" + (int)random(10000) + ".png");
  }
  
  if (millis() > 10000 && midpic == 0) {
    //save("image" + (int)random(10000) + ".png");
    midpic = 1;
  }
}
