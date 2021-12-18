import java.util.*;

class SortDSquared implements Comparator<Integer>
{
  
  SortDSquared (int o)
  {
    origin = o;
  }
  
  int compare (Integer p1, Integer p2)
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
