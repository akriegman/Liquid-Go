import java.util.*;

public class PlayerGo
{
  
  public PlayerGo (color f)
  {
    flag = f;
  }
  
  public int spill (int x, int y, int grams)
  {
    int count = 0;
    int here = y * gameWidth + x;
    
    if (gameState[here] == board)
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
      
      if (gameState[target] == board) {
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
    int x = p % gameWidth;
    int y = (int) p / gameWidth;
    
    gameState[p] = flag;
    
    if (x != 0 && gameState[p-1] == board) {boundary.add(p-1);}
    if (x != gameWidth - 1 && gameState[p+1] == board) {boundary.add(p+1);}
    if (y != 0 && gameState[p-gameWidth] == board) {boundary.add(p-gameWidth);}
    if (y != gameHeight - 1 && gameState[p+gameWidth] == board) {boundary.add(p+gameWidth);}
    boundary.remove(new Integer(p));
  }  
  
  public Set<Integer> boundary = new HashSet();
  public color flag;
}
