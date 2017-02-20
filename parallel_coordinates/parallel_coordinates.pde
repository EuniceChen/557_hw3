import java.util.Map;

HashMap<String,Float> highestNum = new HashMap<String, Float>();
HashMap<String,Float> lowestNum = new HashMap<String, Float>();
String filename = "data.csv";

String[] tableHeaders;
ArrayList<Trend> columnTrends;
Table table;
int numberRows, numberColumns;
ArrayList<LineGroup> groups;

// Selecting box 
boolean boxSelecting = false, boxSelected = false;
Point boxInitPoint = new Point(0, 0), boxEndPoint = new Point(0, 0); 
ArrayList<Line> sides = new ArrayList<Line>();

// Trend
int trendFlipped = -1;

void setup() {
  float topMargin = 0.05 * height, bottomMargin = height - 0.1 * height, leftMargin = 0.1 * width, rightMargin = width - 0.1 * width;
  int sizeOfText = (width + height) / 100;
  size(700, 700);
  loadTable();
  loadLines(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
}

void draw() {
  background(255);
  float topMargin = 0.05 * height, bottomMargin = height - 0.1 * height, leftMargin = 0.1 * width, rightMargin = width - 0.1 * width;
  int sizeOfText = (width + height) / 100;
  if(boxSelecting || boxSelected) {
    drawSelectBox(boxInitPoint, boxEndPoint);
  }
  drawLines();
  drawCoordinates(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
  //drawSelectBoxButton(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
}

void initializeTrend() {
  columnTrends = new ArrayList<Trend>();
  for(int i = 0; i < numberColumns; i++) {
    columnTrends.add(Trend.increasing);
  }
}

void loadLines(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {  
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;
  
  HashMap<String,Float> ratios = new HashMap<String, Float>();
  for(String name : tableHeaders) {
    ratios.put(name, (bottomMargin - topMargin - 2 * sizeOfText) / (highestNum.get(name) - lowestNum.get(name)));
  }
  
  groups = new ArrayList<LineGroup>();
  for(TableRow row : table.rows()) {
    startXpos = leftMargin;
    LineGroup group = new LineGroup();
    for(int i = 0; i < numberColumns - 1; i++) {
      String name1 = tableHeaders[i];
      String name2 = tableHeaders[i + 1];
      Point p1 = new Point(startXpos, (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)));
      Point p2 = new Point(startXpos + interval, (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
      
      if(columnTrends.get(i) == Trend.increasing) {
        p1 = new Point(startXpos, (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)));
      }
      else {
        p1 = new Point(startXpos, (topMargin + sizeOfText) + ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)));
      }
      
      if(columnTrends.get(i + 1) == Trend.increasing) {
        p2 = new Point(startXpos + interval, (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
      }
      else {
        p2 = new Point(startXpos + interval, (topMargin + sizeOfText) + ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
      }
      
      Line l = new Line(p1, p2);
      group.addLine(l);
      //println(name1 + ": " + row.getFloat(name1) + " " + name2 + ": " + row.getFloat(name2));
      //println(startXpos, (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)), startXpos + interval, (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
      startXpos += interval;
    }
    groups.add(group);
  }  
}

void loadTable() {
  String[] lines = loadStrings(filename);
  tableHeaders = split(lines[0], ",");
 
  table = loadTable(filename, "header");
  println(table.getRowCount() + " rows.");
  
  numberRows = table.getRowCount();
  numberColumns =  table.getColumnCount();
  println(numberColumns + " columns.");
  
  for(String name : tableHeaders) {
    print(name + "\t");    
  }
  println();

  for(TableRow row : table.rows()) {
    for(String name : tableHeaders) {
      float value = row.getFloat(name);
      //println("This value: " + value + " high: " + highestNum.get(name));
      //println("This value: " + value + " low: " + lowestNum.get(name));
      print(name + ": " + row.getFloat(name) + "\t");
      if(highestNum.get(name) == null || value >= highestNum.get(name)) {
        highestNum.put(name, value);
      }
      if(lowestNum.get(name) == null || value <= lowestNum.get(name)) {
        lowestNum.put(name, value);
      }
    }
    println();
  }
  initializeTrend();
}

void drawCoordinates(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;

  textSize(sizeOfText);
  textAlign(CENTER);
  //for(String name : tableHeaders) {
  for(int i = 0; i < numberColumns; i++){
    String name = tableHeaders[i];
    fill(0);
    text(highestNum.get(name), startXpos, topMargin);
    text(lowestNum.get(name), startXpos, bottomMargin);
    fill(#797878);
    text(name, startXpos, bottomMargin + 2 * sizeOfText);
    line(startXpos, topMargin + sizeOfText, startXpos, bottomMargin - sizeOfText);
    if(columnTrends.get(i) == Trend.increasing) {
      triangle(startXpos, bottomMargin + 3 * sizeOfText, startXpos - 0.5 * sizeOfText, bottomMargin + 3.5 * sizeOfText, startXpos + 0.5 * sizeOfText, bottomMargin + 3.5 * sizeOfText);
    }
    else {
      triangle(startXpos, bottomMargin + 3.5 * sizeOfText, startXpos - 0.5 * sizeOfText, bottomMargin + 3 * sizeOfText, startXpos + 0.5 * sizeOfText, bottomMargin + 3 * sizeOfText);
    }
    
    if(mouseX >= startXpos - 0.5 * sizeOfText && mouseX <= startXpos + 0.5 * sizeOfText
      && mouseY >= bottomMargin + 3 * sizeOfText && mouseY <= bottomMargin + 3.5 * sizeOfText) {
        trendFlipped = i;
    }
    startXpos += interval;
  }
}

void drawLines() {  
  fill(0);
  stroke(0);
  Point mousePoint = new Point(mouseX, mouseY);
  for(LineGroup group : groups) {
    for(int i = 0; i < group.getCount(); i++) {
      if(isOnSegment(group.getLine(i), mousePoint)) {
        fill(#2E60E5);
        stroke(#2E60E5);
        break;
      }
      if(isLineInBox(group.getLine(i))) {
        fill(#2E60E5);
        stroke(#2E60E5);
        break;
      }
    }
    for(int i = 0; i < group.getCount(); i++) {
      line(group.getPoint1(i).x, group.getPoint1(i).y, group.getPoint2(i).x, group.getPoint2(i).y);
      //println(group.getPoint1(i).x, group.getPoint1(i).y, group.getPoint2(i).x, group.getPoint2(i).y);
    }
    stroke(0);
    fill(0);
  }
}

void drawSelectBoxButton(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {
  fill(255);
  rect(leftMargin, bottomMargin + 3 * sizeOfText , sizeOfText * 5, 1.5 * sizeOfText, sizeOfText / 2.5);
  textAlign(CENTER);
  fill(0);
  text("Select", leftMargin + sizeOfText * 2.5, bottomMargin + 4.1 * sizeOfText );
}

void mousePressed() {
  boxInitPoint = new Point(mouseX, mouseY);
  boxEndPoint = new Point(mouseX, mouseY);
  setSides(boxInitPoint, boxEndPoint);
  boxSelecting = true;
  boxSelected = false;
}

void mouseDragged() {
  stroke(0);
  if(boxSelecting) {
    //rect(boxInitPoint.x, boxInitPoint.y, mouseX - boxInitPoint.x, mouseY - boxInitPoint.y);
    boxEndPoint = new Point(mouseX, mouseY);
    drawSelectBox(boxInitPoint, boxEndPoint);
    setSides(boxInitPoint, boxEndPoint);
  }
}

void mouseReleased() {
  boxSelected = true;
  boxSelecting  = false;
}

void mouseClicked() {
  boxSelected = false;
  float topMargin = 0.05 * height, bottomMargin = height - 0.1 * height, leftMargin = 0.1 * width, rightMargin = width - 0.1 * width;
  int sizeOfText = (width + height) / 100;
  if(trendFlipped != -1) {
    println("Tapped");
    if(columnTrends.get(trendFlipped) == Trend.increasing) {
      columnTrends.set(trendFlipped, Trend.decreasing);
    }
    else {
      columnTrends.set(trendFlipped, Trend.increasing);
    }
    
    loadLines(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
    drawLines();
    trendFlipped = -1;
  }
}

void drawSelectBox(Point initPoint, Point endPoint) {
  
  fill(255);
  rect(initPoint.x, initPoint.y, endPoint.x - initPoint.x, endPoint.y - initPoint.y);
  drawLines();
}

void setSides(Point initPoint, Point endPoint) {
  sides.clear();
  Point p2 = new Point(initPoint.x, endPoint.y), p3 = new Point(endPoint.x, initPoint.y);
  
  sides.add(new Line(initPoint, p2));
  sides.add(new Line(p2, endPoint));
  sides.add(new Line(endPoint, p3));
  sides.add(new Line(p3, initPoint));
}

boolean isLineInBox(Line l) {
  if(boxSelected || boxSelecting) {
    for(int i = 0; i < 4; i++) {
      //println("Side" + i + " " + sides.get(i).a.x, sides.get(i).a.y, sides.get(i).b.x, sides.get(i).b.y);
      //println("l " + l.a.x, l.a.y, l.b.x, l.b.y);
      if(isIntersected(sides.get(i), l)) {
        return true;
      };
    }
    return isInBox(boxInitPoint, boxEndPoint, l);
  }
  return false;
}