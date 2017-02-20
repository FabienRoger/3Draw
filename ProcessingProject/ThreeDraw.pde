import processing.video.*;

SmartCamera video1;
SmartCamera video2;

color trackCol1 = color(255,0,0);
color trackCol2 = color(255,0,0);
boolean showVideo = true;

int resX = 640;
int resY = 480;

float lineWeight = 2;
color lineCol = color(255,255,0);

color drawLedCol = -16761088;
color optionLedCol = -4718592;

int camDrawLed;
int camOptionLed;

//float camHeight = 200;
float camHeight = 200;

float d = 200;
//float d = 320;
float openingAngle1 = 51.5f;
float openingAngle2 = 51.5f;
float xRotDec1 = 0;
float xRotDec2 = 0;
float yRotDec1 = 0;
float yRotDec2 = 0;
//float openingAngle2 = 43.6f;
float verticalOpeningAngle1 = (openingAngle1 * resY)/resX;

String camName1 = "Logitech HD Webcam C270";
String camName2 = "Logitech HD Webcam C310";

ArrayList<PVector> points = new ArrayList<PVector>();

ArrayList<Line> lines = new ArrayList<Line>();
boolean isDrawing = false;
//boolean isDrawingLine = false;
//boolean nPressed = false;
Line actLine = new Line(lineWeight,lineCol);

OptionMenu op = new OptionMenu();

float yPos = -800;
float zPos = 50+camHeight;
float xPos = 0;

int listSize = 50;

boolean ledTrakingEnable = false;
boolean totalSaveEnable = false;
boolean unityTransferEnable = true;
boolean needHelp = true;

boolean objSeen = false;

PositionGenerator generator;
ArrayList<String> sendList = new ArrayList<String>();

void setup(){
  readConfig();
  size(1280,480,P3D);
  println(camName1+" "+camName2+" d =  "+d);
  video1 = new SmartCamera(this,resX,resY,camName1,30,new PVector(0,0));
  video2 = new SmartCamera(this,resX,resY,camName2,30,new PVector(640,0));
  noStroke();
  if(unityTransferEnable){
    generator = new PositionGenerator();
  }
  initModes();
  /*addLine(new Line(5,color(255,0,0)));
  lines.get(0).addPt(50,120,50-camHeight);
  lines.get(0).addPt(190,250,50-camHeight);*/
}

void captureEvent(Capture video){
  video.read();
}

PVector getLastPoint(){
  return points.get(points.size()-1);
}

void mousePressed(){
  if(showVideo){
    
    if(mouseButton == LEFT){
      int loc = (int)((mouseX-video1.pos.x) + (mouseY-video1.pos.y)*video1.width);
       trackCol1 = video1.pixels[loc];
    }else{
      int loc = (int)((mouseX-video2.pos.x) + (mouseY-video2.pos.y)*video2.width);
      trackCol2 = video2.pixels[loc];
    }
    println(trackCol1+" 1");
    println(trackCol2+" 2");
  }
}

void draw(){
  keyPressedCheck();
  
  if(showVideo){
    image(video1,0,0);
    image(video2,640,0);
    noStroke();
    fill(trackCol1);
    rect(video1.pos.x,video1.pos.y,10,10);
    fill(trackCol2);
    rect(video2.pos.x,video2.pos.y,10,10);
    
  }
  if(ledTrakingEnable){
    ledCheck();    
  }

  
  PVector best1 = video1.getBestPixel(trackCol1);
  PVector best2 = video2.getBestPixel(trackCol2);
  
  if(showVideo){
    video1.showBest(best1);
    video2.showBest(best2);
  }
  
  String[] pos = new String[1];
  pos[0]="";
  if(!showVideo){
    draw3DView();
    if(totalSaveEnable){
      //INFO : chaque section séparé par "s", 0 =version, 1 = listSize, 2 = linesSize (variable), 3 = lines (séparé entre eux par "t"), 4 pts act
      pos[0]+=version+"s";
      pos[0]+=listSize+"s";
      pos[0]+=lines.size()+"s";
      for(Line l:lines){
        if(lines.indexOf(l)!=0)pos[0]+="t";
        for(PVector p:l.pts){
          if(l.pts.indexOf(p)!=0)pos[0]+=";";
          pos[0]+=p.x+","+p.y+","+p.z;
        }
      }
      pos[0]+="s";
      for(int i = 0;i<points.size();i++){
        PVector p= points.get(i);
        if(i!=0)pos[0]+=";";
        pos[0]+=p.x+","+p.y+","+p.z;
      }
    }
    
  }else{
    pos[0]=version+"s-1";
  }
  if(totalSaveEnable){
     try{
       saveStrings("datas.txt",pos);
     }catch(Exception e){}
  }
   if(best1.x!=-1&&best2.x!=-1){
     PVector newPt = calcPoint(best1,best2);
     points.add(newPt.copy());
     drawingCheck(newPt.copy());
     if(points.size()>listSize){
       points.remove(0);
     }
     objSeen = true;
   }else{
     objSeen = false;
   }
   camera();
   if(showVideo){
     fill(255);
   }else{
     fill(0);
   }
   text((int)lineWeight,10,10);
   text(drawModes[drawMode],10,30);
   if(!objSeen){
     text("No objective seen",50,10);
   }
   if(!showVideo&&!ledTrakingEnable){
     image(video1,width-2*213,0,213,160);
     image(video2,width-213,0,213,160);
   }
   if(needHelp){
     fill(255);
     text("press H if you need help",20, height-20);
   }
   if(helpActive){
     showHelp();
   }
   if(unityTransferEnable){
     if(!points.isEmpty()){
       PVector lastPt = points.get(points.size()-1);
       generator.updateCord(lastPt.x,lastPt.y,lastPt.z);
     }else{
       generator.simulateRandomPosition(0.5);
     }
   }
   
}

void drawingCheck(PVector p){
  switch(drawMode){
    case NORMALD:
       if(isDrawing)
         addToActLine(p);
      break;
    case ORTHONORMALD:
       if(isDrawing){
         PVector np;
         if(actLine.pts.size()==0){
           np=p.copy();
         }else{
           np = calcOrtho(p,actLine.pts.get(actLine.pts.size()-1));
         }
         addToActLine(np);
       }
      break;
    case STRAIGHTD:
      break;
    case ORTHOSTRAIGHTD:
      break;
    case CUBED:
      break;
    case CTRLZD:
      if(!lines.isEmpty()&&isDrawing){
        Line tl = lines.get(lines.size()-1);
        tl.pts.remove(tl.pts.size()-1);
      }
      break;
    default:
      println("ERROR, draw mode does not exist "+drawModes[drawMode]);
      break;
  }
  /*
  if(nPressed&&!isDrawingLine){
    isDrawingLine = true;
    actLine.addPt(p.copy());
  }
  if(!nPressed&&isDrawingLine){
    
    isDrawingLine = false;
    actLine.addPt(p.copy());
    addLine(actLine.copy());
    actLine.reset();
  }*/
  
}

void ledCheck(){
  SmartCamera tempDrawCam = camDrawLed==1?video1:video2;
  if(tempDrawCam.getBestPixel(drawLedCol).x!=-1/*&&video2.getBestPixel(drawLedCol).x!=-1*/){
    if(drawLedActivated<0){
      drawLedActivated=0;
    }
    if(drawLedActivated==drawActivateResistance){
      //drawLedActivated=0;
      drawEOn();
    }//else{
      drawLedActivated++;
    //}
    /*if(!isDrawing){
      drawEOn();
      actLine.reset();
      isDrawing = true;
    }*/
    //println("Draw led activated "+random(5));
  }else{
    /*if(isDrawing){
      drawEOff();
      
      addLine(actLine.copy());
      actLine.reset();
      isDrawing = false; 
    }*/
    if(drawLedActivated>0){
      drawLedActivated=0;
    }
    if(drawLedActivated==-drawActivateResistance){
      //drawLedActivated=0;
      drawEOff();
    }//else{
      drawLedActivated--;
    //}
  }
  println(drawLedActivated+" draw");
  println(optionLedActivated+" option");
  fill(drawLedCol);
  rect(30+tempDrawCam.pos.x,0,10,10);
  
  SmartCamera tempOptionCam = camOptionLed==1?video1:video2;
  if(tempOptionCam.getBestPixel(optionLedCol).x!=-1/*&&video2.getBestPixel(optionLedCol).x!=-1*/&&!points.isEmpty()){
    if(optionLedActivated==optionActivateResistance){
      //optionLedActivated=0;
      optionE();
    }//else{
      optionLedActivated++;
    //}
    //println("Option led activated "+random(1000));
  }else{
    optionLedActivated=0;
  }
  fill(optionLedCol);
  rect(40+tempOptionCam.pos.x,0,10,10);
}
int optionActivateResistance = 5;
int optionLedActivated = 0;
int drawActivateResistance = 3;
int drawLedActivated = 0;

void addLine(Line l){
  sendList.add("NEWLINE#"+compileLine(l));
  //println(sendList.get(0));
  lines.add(l);
}

void addToActLine(PVector p){
  actLine.addPt(p.x,p.y,p.z);
  sendList.add("ADDPOINT#"+p.x+","+p.y+","+p.z+","+actLine.widths[0]+","+actLine.widths[1]+","+actLine.widths[2]+","+actLine.thisCol);
}