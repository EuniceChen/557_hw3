import java.util.Map;

HashMap<String,Float> highestNum = new HashMap<String, Float>();
HashMap<String,Float> lowestNum = new HashMap<String, Float>();
String filename = "data.csv";

String[] tableHeaders;
Table table;
int numberRows, numberColumns;
ArrayList<LineGroup> groups;

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
  drawLines(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
  drawCoordinates(topMargin, bottomMargin, leftMargin, rightMargin, sizeOfText);
}

void loadLines(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {  
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;
  
  HashMap<String,Float> ratios = new HashMap<String, Float>();
  for(String name : tableHeaders) {
    ratios.put(name, (bottomMargin - topMargin - 2 * sizeOfText) / (highestNum.get(name) - lowestNum.get(name)));
    //println("-------------------------");
    //println("ratio - " + name + ": " + ratios.get(name) + " high: " + highestNum.get(name) + " low: " + lowestNum.get(name));
  }
  
  groups = new ArrayList<LineGroup>();
  for(TableRow row : table.rows()) {
    startXpos = leftMargin;
    LineGroup group = new LineGroup();
    for(int i = 0; i < numberColumns - 1; i++) {
      String name1 = tableHeaders[i];
      String name2 = tableHeaders[i + 1];
      //float yPos1 = (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1));
      //float yPos2 = (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2));
      //println("-------------------------");
      //println(name1, ratios.get(name1));
      Point p1 = new Point(startXpos, (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)));
      Point p2 = new Point(startXpos + interval, (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
      Line l = new Line(p1, p2);
      group.addLine(l);
      println(name1 + ": " + row.getFloat(name1) + " " + name2 + ": " + row.getFloat(name2));
      println(startXpos, (bottomMargin - sizeOfText) - ((row.getFloat(name1) - lowestNum.get(name1)) * 1.0 * ratios.get(name1)), startXpos + interval, (bottomMargin - sizeOfText) - ((row.getFloat(name2) - lowestNum.get(name2)) * 1.0 * ratios.get(name2)));
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
 
}

void drawCoordinates(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;

  textSize(sizeOfText);
  textAlign(CENTER);
  for(String name : tableHeaders) {
    fill(0);
    text(highestNum.get(name), startXpos, topMargin);
    text(lowestNum.get(name), startXpos, bottomMargin);
    fill(#797878);
    text(name, startXpos, bottomMargin + 2 * sizeOfText);
    line(startXpos, topMargin + sizeOfText, startXpos, bottomMargin - sizeOfText);
    startXpos += interval;
  }
}

void drawLines(float topMargin, float bottomMargin, float leftMargin, float rightMargin, int sizeOfText) {  
  fill(0);
  stroke(0);
  for(LineGroup group : groups) {
    for(int i = 0; i < group.getCount(); i++) {
      line(group.getPoint1(i).x, group.getPoint1(i).y, group.getPoint2(i).x, group.getPoint2(i).y);
      //println(group.getPoint1(i).x, group.getPoint1(i).y, group.getPoint2(i).x, group.getPoint2(i).y);
    }
  }
}