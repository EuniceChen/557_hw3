class LineGroup {
  ArrayList<Line> lines;

  LineGroup() {
    lines = new ArrayList<Line>();
  }
  
  void addLine(Line l) {
    lines.add(l);
  }
  
  Line getLine(int i) {
    return lines.get(i);
  }
  
  int getCount() {
    return lines.size();
  }
  
  Point getPoint1(int i) {
    return lines.get(i).a;
  }
  
  Point getPoint2(int i) {
    return lines.get(i).b;
  }
}

class Line {
  Point a, b;
  Line(Point la, Point lb) {
    a = la;
    b = lb;
  }
}

class Point {
  float x, y;
  
  Point(float px, float py) {
    x = px;
    y = py;
  }
}

enum trend {
  up, down
}