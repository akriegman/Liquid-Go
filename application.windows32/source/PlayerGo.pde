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
  
  public void assimilate (int p) {
    int x = p % width;
    int y = (int) p / width;
    
    pixels[p] = flag;
    
    if (x != 0 && pixels[p-1] == board) {boundary.add(p-1);}
    if (x != width - 1 && pixels[p+1] == board) {boundary.add(p+1);}
    if (y != 0 && pixels[p-width] == board) {boundary.add(p-width);}
    if (y != height - 1 && pixels[p+width] == board) {boundary.add(p+width);}
    boundary.remove(new Integer(p));
  }  
  
  //public int topologyCheck () {
  //  Set<Integer> buffer = new HashSet();
  //  buffer.addAll(boundary);
  //  while (buffer.size() > 0) {
  //    ArrayList<Integer> loop = new ArrayList();
  //  }
    
  //}
  
  public Set<Integer> boundary = new HashSet();
  //public PriorityQueue<Integer> boundary = new PriorityQueue();
  public color flag;
}
