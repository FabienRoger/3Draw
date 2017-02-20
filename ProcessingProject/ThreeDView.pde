int screenSize = 100;
int camSize = 20;
int screenDepth = 10;
void draw3DView(){
   noStroke();
   lights();
   camera(xPos,yPos,zPos,
     0,0,0,
     0,-1,0);
   background(0);
   /*
   fill(255,0,0);
   box(10000,5,5);
   fill(0,255,0);
   box(5,10000,5);
   fill(0,0,255);
   box(5,5,10000);
   */
   fill(255);
   box(10000,5,10000);
   fill(200);
   pushMatrix();
   translate(0,0,0);
   box(10000,10000,5);
   fill(0);
   popMatrix();
   pushMatrix();
   translate(d/2,-camSize/2,0);
   box(camSize,camSize,10000);
   translate(-d,0,0);
   box(camSize,camSize,10000);
   popMatrix();
   fill(100);
   pushMatrix();
   translate(0,0,-screenSize/2);
   box(d,screenDepth,screenSize);
   popMatrix();
   noStroke();
   for(Line l:lines){
      l.show(false);
   }
   for(int i = lines.size()-1;i>=0;i--){
     if(lines.get(i).pts.size()==0){
       lines.remove(i);
     }
   }
   actLine.show(isDrawing/*||isDrawingLine*/);
   if(objSeen){/*
     for(int i = 0;i<points.size();i++){
       PVector p= points.get(i);
       drawP(p,lineCol,lineWeight*wFRatio);
     }*/
     drawP(getLastPoint(),lineCol,lineWeight*wFRatio);
   }
   op.show();
}

void drawP(PVector p){
  //fill(0,map(p.y,0,500,0,255),0);
  fill(0,255,0);
  pushMatrix();
  translate(-p.x,-p.y,-p.z);
  sphere(10);
  popMatrix();
  //ellipse(p.x,p.y+480,10,10);
}

void drawP(PVector p,color col,float size){
  //fill(0,map(p.y,0,500,0,255),0);
  //println(p);
  fill(col);
  pushMatrix();
  translate(-p.x,-p.y,-p.z);
  sphere(size);
  popMatrix();
  //ellipse(p.x,p.y+480,10,10);
}

void drawBox(PVector p,int size,color col){
  //fill(0,map(p.y,0,500,0,255),0);
  fill(col);
  pushMatrix();
  translate(-p.x,-p.y,-p.z);
  box(size);
  popMatrix();
  //ellipse(p.x,p.y+480,10,10);
}

void drawText(String txt, float px, float py, float pz){
  //pushMatrix();
  //translate(-px,-py,-pz);
  fill(255);
  textSize(100);
  text(txt,-px,-py,-pz);
  //popMatrix();
}

void drawIcons(float boxS, float px, float py, float pz){
  pushMatrix();
  translate(-px+boxS/2,-py,-pz);
  translate(-boxS/12,0,0);
  fill(0,0,255,100);
  sphere(boxS/10);
  translate(-boxS/4,0,0);
  fill(150,150,150,100);
  box(boxS/8);
  translate(-boxS/3,0,0);
  fill(150,150,150,100);
  sphere(boxS/8);
  translate(-boxS/4,0,0);
  rotateY(radians(45));
  fill(150,150,150,100);
  box(boxS/8);
  rotateY(-radians(45));
  popMatrix();
  
}