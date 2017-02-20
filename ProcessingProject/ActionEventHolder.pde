void optionE(){
  if(!points.isEmpty()){
    op.incrementState(getLastPoint());
  }
}

void drawEOn(){
  actLine.reset();
  isDrawing = true; 
  if(drawMode==STRAIGHTD&&!points.isEmpty()){
    addToActLine(getLastPoint());
  }
  if(drawMode==ORTHOSTRAIGHTD&&!points.isEmpty()){
    addToActLine(getLastPoint());
  }
  if(drawMode==CUBED&&!points.isEmpty()){
    addToActLine(getLastPoint());
    actLine.isCube=true;
  }
}

void drawEOff(){
  if(!actLine.pts.isEmpty()){
    if(drawMode==STRAIGHTD){
    actLine.addPt(getLastPoint());
    }
    if(drawMode==CUBED&&actLine.pts.size()>0){
      actLine.pts.get(0).x-=actLine.widths[0]/2;
      actLine.pts.get(0).y-=actLine.widths[1]/2;
      actLine.pts.get(0).z-=actLine.widths[2]/2;
      actLine.widths[0]=abs(actLine.widths[0]);
      actLine.widths[1]=abs(actLine.widths[1]);
      actLine.widths[2]=abs(actLine.widths[2]);
    }
    if(drawMode==ORTHOSTRAIGHTD){
      actLine.addPt(calcOrtho(getLastPoint(),actLine.pts.get(0)));
    }
    if(!actLine.pts.isEmpty()){
      addLine(actLine.copy());
    }
    actLine.reset();
  }
  isDrawing = false;
}

void changeModeE(){
  incrementMode();
  println(drawModes[drawMode]);
}