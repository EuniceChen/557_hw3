boolean isIntersected(Line l1, Line l2) {
  return ((max(l1.a.x, l1.b.x) >= min(l2.a.x, l2.b.x)) &&
          (max(l2.a.x, l2.b.x) >= min(l1.a.x, l1.b.x)) &&
          (max(l1.a.y, l1.b.y) >= min(l2.a.y, l2.b.y)) &&
          (max(l2.a.y, l2.b.y) >= min(l1.a.y, l1.b.y)) &&
          (multiply(l2.a, l1.b, l1.a) * multiply(l1.b, l2.b, l1.a) >= 0) &&
          (multiply(l1.a, l2.b, l2.a) * multiply(l2.b, l1.b, l2.a) >= 0)) ;
}

boolean isOnSegment(Line l, Point p) {
  if(min(l.a.x, l.b.x) <= p.x && p.x <= max(l.a.x, l.b.x) &&
    min(l.a.y, l.b.y) <= p.y && p.y <= max(l.a.y, l.b.y) &&
    multiply(l.a, l.b, p) == 0) {
    return true;
  }
  
  return false;
}

float multiply(Point p1,Point p2,Point p0) { 
  return((p1.x-p0.x)*(p2.y-p0.y)-(p2.x-p0.x)*(p1.y-p0.y)); 
} 

boolean isInBox(Point initPoint, Point endPoint, Line l) {
  return (min(l.a.x, l.b.x) >= min(initPoint.x, endPoint.x) && min(l.a.y, l.b.y) >= min(initPoint.y, endPoint.y) && 
    max(l.a.x, l.b.x) <= max(initPoint.x, endPoint.x) && max(l.a.y, l.b.y) <= max(initPoint.y, endPoint.y));
}