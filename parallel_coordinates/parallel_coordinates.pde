import java.util.Map;

HashMap<String,Float> highestNum = new HashMap<String, Float>();
HashMap<String,Float> lowestNum = new HashMap<String, Float>();
//String filename = "data.csv";
String filename = "real_population_USA.csv";

ArrayList<String> tableHeaders;
ArrayList<Trend> columnTrends;
Table table;
int numberRows, numberColumns;
ArrayList<LineGroup> groups;
String nameHeader;

float topMargin, bottomMargin, leftMargin, rightMargin;
int sizeOfText;

// Selecting box 
boolean boxSelecting = false, boxSelected = false;
Point boxInitPoint = new Point(0, 0), boxEndPoint = new Point(0, 0); 
ArrayList<Line> sides = new ArrayList<Line>();
// Trend
int trendFlipped = -1;
Point trendMouse;
int trendColored = -1, dimensionToColor = 0;
Point colorMouse;
float displayHeightRange = 0;

//dimenstion selecting
boolean dimSelectEnabled = false;
Point dimSelectPoint1, dimSelectPoint2;
float UP_SLIDER_BOUND, DOWN_SLIDER_BOUND;
ArrayList<Float> upSlidersValue, downSlidersValue;
ArrayList<Boolean> upDragging, downDragging;

void setup() {
  topMargin = 0.05 * height; bottomMargin = height - 0.1 * height; leftMargin = 0.1 * width; rightMargin = width - 0.1 * width;
  sizeOfText = (width + height) / 100;
  displayHeightRange = bottomMargin - topMargin - 2 * sizeOfText;
  
  dimSelectPoint1 = new Point(width - 2 * sizeOfText, height - 2 * sizeOfText);
  dimSelectPoint2 = new Point(width - sizeOfText, height - sizeOfText);
  dimensionSelectButton();
  size(700, 700);
  loadTable();
  loadLines();
  initializeDimensionSelector();
}

void draw() {
  background(255);
  if(boxSelecting || boxSelected) {
    drawSelectBox(boxInitPoint, boxEndPoint);
  }
  drawLines();
  drawCoordinates();
  
  dimensionSelectButton();
}

void initializeDimensionSelector() {
  UP_SLIDER_BOUND = topMargin + sizeOfText;
  DOWN_SLIDER_BOUND = bottomMargin - sizeOfText;

  upSlidersValue = new ArrayList<Float>();
  downSlidersValue = new ArrayList<Float>();
  upDragging = new ArrayList<Boolean>();
  downDragging = new ArrayList<Boolean>();
  
  for(int i = 0; i < numberColumns; i++) {
    upSlidersValue.add(UP_SLIDER_BOUND);
    downSlidersValue.add(DOWN_SLIDER_BOUND);
    upDragging.add(false);
    downDragging.add(false);
  }
}

void dimensionSelectButton() {
  fill(255);
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;
  if(dimSelectEnabled) {
    textAlign(RIGHT);
    fill(0);
    textSize(sizeOfText / 1.5);
    text("Now drag the two arrows (up and down) on each dimension.", dimSelectPoint1.x, dimSelectPoint1.y + 1.5 * sizeOfText);
    fill(255);
    for(int i = 0; i < numberColumns; i++) {    
      drawUpSlider(startXpos, upSlidersValue.get(i));
      drawDownSlider(startXpos, downSlidersValue.get(i));
      startXpos += interval;
    }
    fill(#25E345);
  }
  else{
    textAlign(RIGHT);
    fill(0);
    textSize(sizeOfText / 1.5);
    text("Click the Square!", dimSelectPoint1.x, dimSelectPoint1.y + 1.5 * sizeOfText);
    fill(255);
  }
  rect(dimSelectPoint1.x, dimSelectPoint1.y, dimSelectPoint2.x - dimSelectPoint1.x, dimSelectPoint2.y - dimSelectPoint1.y);
}

void drawUpSlider(float xPos, float level) {
  
  triangle(xPos, level - 5, xPos - 5, level, xPos + 5, level);
}

void drawDownSlider(float xPos, float level) {
  triangle(xPos, level + 5, xPos - 5, level, xPos + 5, level);
}

void initializeTrend() {
  columnTrends = new ArrayList<Trend>();
  for(int i = 0; i < numberColumns; i++) {
    columnTrends.add(Trend.increasing);
  }
}

void loadLines() {  
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
      String name1 = tableHeaders.get(i);
      String name2 = tableHeaders.get(i + 1);
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
      group.setName(row.getString(nameHeader));
      
      startXpos += interval;
    }
    groups.add(group);
  }  
}

void loadTable() {
  String[] lines = loadStrings(filename);
  String[] allHeaders = split(lines[0], ",");
  nameHeader = allHeaders[0];
  tableHeaders = new ArrayList<String>();
  for(int i = 1; i < allHeaders.length; i++) {
    tableHeaders.add(allHeaders[i]);
  }
 
  table = loadTable(filename, "header");
  
  numberRows = table.getRowCount();
  numberColumns =  table.getColumnCount() - 1;

  for(TableRow row : table.rows()) {
    for(String name : tableHeaders) {
      float value = row.getFloat(name);
      if(highestNum.get(name) == null || value >= highestNum.get(name)) {
        highestNum.put(name, value);
      }
      if(lowestNum.get(name) == null || value <= lowestNum.get(name)) {
        lowestNum.put(name, value);
      }
    }
  }
  initializeTrend();
}

void drawCoordinates() {
  float interval = (rightMargin - leftMargin) / (numberColumns - 1);
  float startXpos = leftMargin;

  textSize(sizeOfText);
  textAlign(CENTER);
  for(int i = 0; i < numberColumns; i++){
    String name = tableHeaders.get(i);
    fill(0);
    if(dimensionToColor == i && dimSelectEnabled == false) {
      fill(200, 0, 0);
    }
    
    if(columnTrends.get(i) == Trend.increasing) {
      text(highestNum.get(name), startXpos, topMargin);
      text(lowestNum.get(name), startXpos, bottomMargin);
    }
    else {
      text(lowestNum.get(name), startXpos, topMargin);
      text(highestNum.get(name), startXpos, bottomMargin);
    }
    
    fill(255);
    rect(startXpos - 2 * sizeOfText, bottomMargin + sizeOfText, 4 * sizeOfText, 1.5 * sizeOfText, sizeOfText);
    
    fill(#797878);
    if(dimensionToColor == i && dimSelectEnabled == false) {
      fill(#D88888);
    }
    
    text(name, startXpos, bottomMargin + 2 * sizeOfText);
     
    // Dimension Color
    if(mouseX >= startXpos - 2 * sizeOfText && mouseX <= startXpos + 4 * sizeOfText &&
      mouseY >= bottomMargin + sizeOfText && mouseY <= bottomMargin + 2 * sizeOfText) {
       trendColored = i;
       colorMouse = new Point(mouseX, mouseY);
     }
    
    line(startXpos, topMargin + sizeOfText, startXpos, bottomMargin - sizeOfText);
    
    // Trend
    if(!dimSelectEnabled) {
      if(columnTrends.get(i) == Trend.increasing) {
        triangle(startXpos, bottomMargin + 3 * sizeOfText, startXpos - 0.5 * sizeOfText, bottomMargin + 3.5 * sizeOfText, startXpos + 0.5 * sizeOfText, bottomMargin + 3.5 * sizeOfText);
      }
      else {
        triangle(startXpos, bottomMargin + 3.5 * sizeOfText, startXpos - 0.5 * sizeOfText, bottomMargin + 3 * sizeOfText, startXpos + 0.5 * sizeOfText, bottomMargin + 3 * sizeOfText);
      }
    }
    
    if(mouseX >= startXpos - 0.5 * sizeOfText && mouseX <= startXpos + 0.5 * sizeOfText
      && mouseY >= bottomMargin + 3 * sizeOfText && mouseY <= bottomMargin + 3.5 * sizeOfText) {
        trendFlipped = i;
        trendMouse = new Point(mouseX, mouseY);
    }
    startXpos += interval;
  }
}

void drawLines() {  
  fill(0);
  stroke(0);
  for(int i = 0; i < numberRows; i++) {
    LineGroup group = groups.get(i);
    float coloringRatio = group.getPoint(dimensionToColor).y / displayHeightRange;
    color lineColor = color(255, 0, 0, 255 - 200 * coloringRatio);
    
    stroke(lineColor);
    strokeWeight(1);
    if(dimSelectEnabled) {
      stroke(#710400);
    }
    if(!dimSelectEnabled) {
      for(int j = 0; j < group.getCount(); j++) {
        if(isLineInBox(group.getLine(j))) {
          fill(#1E91D6);
          stroke(#1E91D6);
          strokeWeight(1.5);
        }
      }
    }
    else {
      for(int j = 0; j < numberColumns; j++) {
        if(upSlidersValue.get(j) - 0.5 > group.getPoint(j).y || group.getPoint(j).y > downSlidersValue.get(j) + 0.5) {
          stroke(#FFD6D6);
        }
      }
    }
    
    textAlign(LEFT);
    for(int j = 0; j < group.getCount(); j++) {
      if(isMouseOnSegment(group.getLine(j))) {
          fill(#541ED6);
          stroke(#541ED6);
          strokeWeight(1.5);
          text(group.name, group.getPoint1(0).x - 3 * sizeOfText, group.getPoint1(0).y);
        }
    }
    textAlign(CENTER);
    for(int j = 0; j < group.getCount(); j++) {
      line(group.getPoint1(j).x, group.getPoint1(j).y, group.getPoint2(j).x, group.getPoint2(j).y);
    }
    strokeWeight(1);
    stroke(0);
    fill(0);
  }
}

void drawSelectBoxButton() {
  fill(255);
  rect(leftMargin, bottomMargin + 3 * sizeOfText , sizeOfText * 5, 1.5 * sizeOfText, sizeOfText / 2.5);
  textAlign(CENTER);
  fill(0);
  text("Select", leftMargin + sizeOfText * 2.5, bottomMargin + 4.1 * sizeOfText );
}

void mousePressed() {
  if(dimSelectEnabled == false) {
    boxInitPoint = new Point(mouseX, mouseY);
    boxEndPoint = new Point(mouseX, mouseY);
    setSides(boxInitPoint, boxEndPoint);
    boxSelecting = true;
    boxSelected = false;
   }
   else {
    float interval = (rightMargin - leftMargin) / (numberColumns - 1);
    float startXpos = leftMargin;
    for(int i = 0; i < numberColumns; i++) {
      if(startXpos - 5 <= mouseX && mouseX <= startXpos + 5 
        && upSlidersValue.get(i) - 5 <= mouseY && mouseY <= upSlidersValue.get(i)) {
        upDragging.set(i, true);
      }
       
      if(startXpos - 5 <= mouseX && mouseX <= startXpos + 5 
       && downSlidersValue.get(i) <= mouseY && mouseY <= downSlidersValue.get(i) + 5) {
         downDragging.set(i, true);
      }
      startXpos += interval;
     }
   }
}

void mouseDragged() {
  if(dimSelectEnabled == false) {
    stroke(0);
    if(boxSelecting) {
      boxEndPoint = new Point(mouseX, mouseY);
      drawSelectBox(boxInitPoint, boxEndPoint);
      setSides(boxInitPoint, boxEndPoint);
    }
  }
  else {
    for(int i = 0; i < numberColumns; i++) {
        if(upDragging.get(i) == true) {
          if(mouseY <= UP_SLIDER_BOUND) upSlidersValue.set(i, UP_SLIDER_BOUND);
          else if(mouseY > downSlidersValue.get(i)) upSlidersValue.set(i, downSlidersValue.get(i));
          else upSlidersValue.set(i, mouseY - 2.5);
        }
        
        if(downDragging.get(i) == true) {
          if(mouseY >= DOWN_SLIDER_BOUND) downSlidersValue.set(i, DOWN_SLIDER_BOUND);
          else if(mouseY < upSlidersValue.get(i)) downSlidersValue.set(i, upSlidersValue.get(i));
          else  downSlidersValue.set(i, mouseY - 2.5);
        }
    }
    
  }
}

void mouseReleased() {
  if(dimSelectEnabled == false) {
    boxSelected = true;
    boxSelecting  = false;
  }
  else {
    for(int i = 0; i < numberColumns; i++) {
      upDragging.set(i, false);
      downDragging.set(i, false);
    }
  }
}

void mouseClicked() {
  boxSelected = false;
  
  if(dimSelectPoint1.x <= mouseX && mouseX <= dimSelectPoint2.x &&
    dimSelectPoint1.y <= mouseY && mouseY <= dimSelectPoint2.y) {
    dimSelectEnabled = dimSelectEnabled == false ? true : false;
    return;
  }
  
  
  if(trendFlipped != -1 && mouseX == trendMouse.x && mouseY == trendMouse.y) {
    if(columnTrends.get(trendFlipped) == Trend.increasing) {
      columnTrends.set(trendFlipped, Trend.decreasing);
    }
    else {
      columnTrends.set(trendFlipped, Trend.increasing);
    }
    
    loadLines();
    drawLines();
    drawCoordinates();
    trendFlipped = -1;
  }
  
  if(trendColored != -1 && mouseX == colorMouse.x && mouseY == colorMouse.y) {
    dimensionToColor = trendColored;
    trendColored = -1;

    drawLines();
    drawCoordinates();
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
      if(isIntersected(sides.get(i), l)) {
        return true;
      };
    }
    return isInBox(boxInitPoint, boxEndPoint, l);
  }
  return false;
}

boolean isMouseOnSegment(Line l) {
  ArrayList<Line> mouseBox = new ArrayList<Line>();
  Point p1 = new Point(mouseX - 1, mouseY - 1), 
        p2 = new Point(mouseX + 1, mouseY - 1),
        p3 = new Point(mouseX + 1, mouseY + 1),
        p4 = new Point(mouseX - 1, mouseY + 1);
  mouseBox.add(new Line(p1, p2));
  mouseBox.add(new Line(p2, p3));
  mouseBox.add(new Line(p3, p4));
  mouseBox.add(new Line(p4, p1));
  for(int i = 0; i < 4; i++) {
      if(isIntersected(mouseBox.get(i), l)) {
        return true;
      };
  }
  return isInBox(p1, p3, l);
}