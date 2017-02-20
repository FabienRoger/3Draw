final int COLOROP = 1;
final int DRAWMODEOP = 2;
final int BRUSHSIZEOP = 3;
final int MOVEPIECEOP = 4;

class OptionMenu{
  boolean active = false;
  PVector pos;
  int state = 0;
  int optionCase = 0;
  int boxSize = 100;
  
  color tCol;
  
  float tempLineWeight = lineWeight;
  int tempDrawMode = drawMode;
  
  OptionMenu(){
    
  }
  
  void show(){
    if(active){
      if(!isInBox()){
        disable();
      }
      PVector relativePos = (getLastPoint().copy().sub(pos));
      switch(optionCase){
        case COLOROP:
          tCol = color(map(relativePos.x,-boxSize/2f,boxSize/2f,0,254),map(relativePos.y,-boxSize/2f,boxSize/2f,0,254),map(relativePos.z,-boxSize/2f,boxSize/2f,0,254));
          break;
        case BRUSHSIZEOP:
          tempLineWeight = map(relativePos.z,-boxSize/2f,boxSize/2f,0,20);
          break;
        case DRAWMODEOP:
          drawMode = (int)map(relativePos.z,-boxSize/2f,boxSize/2f,0,drawModes.length);
          break;
        case MOVEPIECEOP:
          moveAll(map(relativePos.x,-boxSize/2f,boxSize/2f,-1,1),map(relativePos.y,-boxSize/2f,boxSize/2f,-1,1),map(relativePos.z,-boxSize/2f,boxSize/2f,-1,1));
          break;
      }
      drawP(pos,tCol,tempLineWeight*wFRatio);
      if(state==1){
        //drawText("Color",pos.x,pos.y,pos.z);
        //drawText("Draw mode",pos.x,pos.y,pos.z);
        //drawText("Brush size",pos.x,pos.y,pos.z);
        drawIcons(boxSize,pos.x,pos.y,pos.z);
      }
      drawBox(pos,boxSize,color(255,252*optionCase/3,0,50));
      
    }
  }
  void incrementState(PVector pos){
    switch(state){
      case 0:
        state++;
        enable(pos);
        break;
      case 1:
        defineOptionCase();
        state++;
        break;
      case 2:
        state=0;
        getResult();
        disable();
        break;
    }
  }
  
  void enable(PVector pos){
    active = true;
    optionCase=0;
    this.pos = pos.copy();
    tempLineWeight = lineWeight;
    tempDrawMode = drawMode;
    tCol = color(255,0,0);
  }
  
  void defineOptionCase(){
    if(isInBox()){
      if(pos.x-boxSize/4>getLastPoint().x){
        optionCase=COLOROP;
      }else if(pos.x-boxSize/4<getLastPoint().x&&pos.x>getLastPoint().x){
        optionCase = DRAWMODEOP;
      }else if(pos.x<getLastPoint().x&&pos.x+boxSize/4>getLastPoint().x){
        optionCase = BRUSHSIZEOP;
      }else{
        optionCase = MOVEPIECEOP;
      }
    }else{
      optionCase = 0;
    }
    
  }
  
  boolean isInBox(){
    return abs(pos.y-getLastPoint().y)<boxSize/2&&abs(pos.z-getLastPoint().z)<boxSize/2&&abs(pos.x-getLastPoint().x)<boxSize/2;
  }
  
  void getResult(){
    switch(optionCase){
      case COLOROP:
        PVector relativePos = (getLastPoint().sub(pos));
        lineCol = color(map(relativePos.x,-boxSize/2f,boxSize/2f,0,254),map(relativePos.y,-boxSize/2f,boxSize/2f,0,254),map(relativePos.z,-boxSize/2f,boxSize/2f,0,254));
        break;
      case BRUSHSIZEOP:
        lineWeight = tempLineWeight;
        break;
      case DRAWMODEOP:
        tempDrawMode = drawMode;
        break;
    }
  }
  
  void disable(){
    tCol = color(255,0,0);
    drawMode=tempDrawMode;
    active = false;
    state=0;
    optionCase=0;
  }
  
  
}

void moveAll(float dx,float dy,float dz){
  PVector shift = new PVector(dx,dy,dz);
  for(Line l:lines){
    for(PVector p:l.pts){
      p.add(shift);
    }
  }
}