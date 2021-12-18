import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.time.LocalDateTime; 
import java.nio.file.Paths; 
import java.util.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LiquidGo extends PApplet {





PlayerGo player1;
PlayerGo player2;
int board = color(180, 140, 30);
int growRate = 30;
float computerX;
float computerY;
float computerXnext;
float computerYnext;
float playerX;
float playerY;
float playerXnext;
float playerYnext;
float speed = 0.2f;
boolean pause = false;

public void setup ()
{
  background(board);
  
  loadPixels();
  
  player1 = new PlayerGo(color(255, 255, 224));
  player2 = new PlayerGo(color(0, 0, 32));
  mouseX = width/4;
  mouseY = height/2;
  playerX = width/4;
  playerY = height/2;
  computerX = width/4*3;
  computerY = height/2;
}

public void draw ()
{ 
  if (millis() < 2000 || pause) { return; }
  
  // Player coordinates should be 0 <= x < width, similar for y.
  // Since we round down to get the cell coordinates,
  // and the player coordinates are only approaching the mouse
  // coordinates, it's okay to clamp mouseX above by width
  // instead of width - 1.
  mouseX = Math.max(0, Math.min(width, mouseX));
  mouseY = Math.max(0, Math.min(height, mouseY));
  
  computerXnext = computerX + (mouseX - computerX) * speed/2;
  computerYnext = computerY + (mouseY - computerY) * speed/2;
  playerXnext = playerX + (mouseX - playerX) * speed;
  playerYnext = playerY + (mouseY - playerY) * speed;
  
  for (int i = 0; i < growRate; i++) {
    //computerX += (mouseX - computerX) * speed/2;
    //computerY += (mouseY - computerY) * speed/2;
    //playerX += (mouseX - playerX) * speed;
    //playerY += (mouseY - playerY) * speed;
    
    player1.spill(PApplet.parseInt(playerX * PApplet.parseFloat(growRate - i) / growRate + playerXnext * PApplet.parseFloat(i) / growRate), 
                  PApplet.parseInt(playerY * PApplet.parseFloat(growRate - i) / growRate + playerYnext * PApplet.parseFloat(i) / growRate), 1);
    
    //player1.spill(mouseX, mouseY, 1);
    //player2.spill((int) (width/2 + cos((float) millis()/1000)*height/4), (int) (height/2 + sin((float) millis()/1000)*height/4), 1);
    player2.spill(PApplet.parseInt(computerX * PApplet.parseFloat(growRate - i) / growRate + computerXnext * PApplet.parseFloat(i) / growRate), 
                  PApplet.parseInt(computerY * PApplet.parseFloat(growRate - i) / growRate + computerYnext * PApplet.parseFloat(i) / growRate), 1);
  }
  updatePixels();
  
  computerX = computerXnext;
  computerY = computerYnext;
  playerX = playerXnext;
  playerY = playerYnext;
  
  if (player2.boundary.size() == 0 && player1.boundary.size() == 0) {
    noLoop();
    int w = 0;
    int b = 0;
    int u = 0;
    for (int c : pixels) {
      if (c == player1.flag) {w++;};
      if (c == player2.flag) {b++;};
      if (c == board) {u++;};
    }
    println("White Territory: " + (w + u));
    println("Black Territory: " + b);
    screenshot();
  }
}

public void keyPressed ()
{
  switch (key) {
    case 's': screenshot();   break;
    case 'p': pause = !pause; break;
    case 'j': growRate -= 10; break;
    case 'k': growRate += 10; break;
  }
}

public void screenshot()
{
  save("screenshots/image_" + LocalDateTime.now().toString().replace(':', '-') + ".png");
}


public class PlayerGo
{
  
  public PlayerGo (int f)
  {
    flag = f;
  }
  
  public int spill (int x, int y, int grams)
  {
    int count = 0;
    int here = y * width + x;
    
    if (pixels[here] == board)
    {
      assimilate(here);
      count++;
    }
    
    SortDSquared sorty = new SortDSquared(here);
    
    while (count < grams)
    {
      int target;
      try {
        target = Collections.min(boundary, sorty);
      } catch (NoSuchElementException e) {return 0;}
      
      if (pixels[target] == board) {
        assimilate(target);
        count++;
      } else {
        boundary.remove(new Integer(target));
      }
    }
    return 1;
  }
  
  public void assimilate (int p)
  {
    int x = p % width;
    int y = (int) p / width;
    
    pixels[p] = flag;
    
    if (x != 0 && pixels[p-1] == board) {boundary.add(p-1);}
    if (x != width - 1 && pixels[p+1] == board) {boundary.add(p+1);}
    if (y != 0 && pixels[p-width] == board) {boundary.add(p-width);}
    if (y != height - 1 && pixels[p+width] == board) {boundary.add(p+width);}
    boundary.remove(new Integer(p));
  }  
  
  public Set<Integer> boundary = new HashSet();
  //public PriorityQueue<Integer> boundary = new PriorityQueue();
  public int flag;
}


class SortDSquared implements Comparator<Integer>
{
  
  SortDSquared (int o)
  {
    origin = o;
  }
  
  public int compare (Integer p1, Integer p2)
  {
    return dsquared(origin, p1) - dsquared(origin, p2);
  }
  
  public int dsquared (int p1, int p2)
  {
    return (int) Math.pow((int)(p1/width) - (int)(p2/width), 2)
    + (int) Math.pow(p1 % width - p2 % width, 2);
  }
  
  int origin;
  
}
  public void settings() {  size(720, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LiquidGo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
