class LineGroup {
  ArrayList<Line> lines;
  String name;
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
  
  Point getPoint(int i) {
    if(i == 0) return getPoint1(0);
    else return getPoint2(i - 1);
  }
  
  void setName(String groupName) {
    name = groupName;
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

enum Trend {
  increasing, decreasing
}