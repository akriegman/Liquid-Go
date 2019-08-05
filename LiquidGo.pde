import java.util.*;

PlayerGo player1;
PlayerGo player2;
color board = color(140, 100, 10);
int growRate = 100;

void setup ()
{
  background(board);
  size(800, 600);
  player1 = new PlayerGo(color(255, 255, 235));
  player2 = new PlayerGo(color(0, 0, 32));
  mouseX = width/2;
  mouseY = height/2;
  loadPixels();
}

void draw ()
{
  player1.spill(mouseX, mouseY, growRate);
  player2.spill((int) (width/2 + cos(millis()/1000)*height/4), (int) (height/2 + sin(millis()/1000)*height/4), growRate);
  updatePixels();
  
  if (player2.boundary.size() == 0) {
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
  }
  
  //if (millis() > 5000) {
  //  noLoop();
  //  for (int p : player1.boundary) {
  //    pixels[p] = color(255, 0, 0);
  //  }
  //  updatePixels();
  //}
}
