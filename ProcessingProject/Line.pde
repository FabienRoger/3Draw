int wFRatio = 2;
class Line{
  ArrayList<PVector> pts = new ArrayList<PVector>();
  //float weight;
  float[] widths = new float[3];
  color thisCol;
  boolean isCube = false;
  Line(float weight,int col){
    this.widths[0]=weight;
    this.widths[1]=weight;
    this.widths[2]=weight;
    thisCol=col;
  }
  Line(float weight0,float weight1,float weight2,int col){
    this.widths[0]=weight0;
    this.widths[1]=weight1;
    this.widths[2]=weight2;
    thisCol=col;
  }
  
  void addPt(float spX, float spY, float spZ){
    addPt(new PVector(spX,spY,spZ));
  }
  void addPt(PVector p){
    pts.add(p);
  }
  void show(boolean isDrawing){
    if(!pts.isEmpty()){
      if(isDrawing){
        if(drawMode==ORTHOSTRAIGHTD||drawMode==ORTHONORMALD){
          pts.add((calcOrtho(getLastPoint(),pts.get(pts.size()-1))));
        }else{
          pts.add(getLastPoint());
        }
      }
        
      for(int i =0;i<pts.size();i++){
        //lineDraw(i);
        //formDraw(i);
        if(isCube){
          drawCube(i);
        }else{
          formDrawV2(i);
        }
      }
      if(isDrawing){
        pts.remove(pts.get(pts.size()-1));
      }
    }
    noStroke();
  }
  
  void lineDraw(int i){
    stroke(thisCol);
    strokeWeight(widths[0]);
    if(i!=0)
      line(-pts.get(i-1).x,-pts.get(i-1).y,-pts.get(i-1).z,-pts.get(i).x,-pts.get(i).y,-pts.get(i).z);
    noStroke();
  }
  void formDraw(int i){
    fill(thisCol);
    pushMatrix();
    translate(-pts.get(i).x,-pts.get(i).y,-pts.get(i).z);
    sphere(wFRatio*widths[0]);
    popMatrix();
    if(i!=0){
      float alpha = 0;
      float beta = 0;
      float teta = 0;
      
      float x1 = pts.get(i).x;
      float y1 = pts.get(i).y;
      float z1 = pts.get(i).z;
      float x2 = pts.get(i-1).x;
      float y2 = pts.get(i-1).y;
      float z2 = pts.get(i-1).z;
      
      if(y1!=y2){
        alpha=atan((z1-z2)/(y1-y2));
        teta=PI/2-atan((x1-x2)/(y1-y2));
      }else{
        if(z2!=z1){
          beta = PI/2+atan((x2-x1)/(z2-z1));
        }
      }
      pushMatrix();
      translate((-x1-x2)/2,(-y1-y2)/2,(-z1-z2)/2);
      rotateX(alpha);
      rotateY(beta);
      rotateZ(teta);
      box(dist(x1,y1,z1,x2,y2,z2),wFRatio*widths[0],wFRatio*widths[0]);
      popMatrix();
    }
  }
  void formDrawV2(int i){
    fill(thisCol);
    
    float bsX = wFRatio*widths[0];
    float bsY = wFRatio*widths[1];
    float bsZ = wFRatio*widths[2];
    
    float x1 = -pts.get(i).x+bsX/2;
    float y1 = -pts.get(i).y+bsY/2;
    float z1 = -pts.get(i).z+bsZ/2;
    
    noStroke();
    pushMatrix();
    translate(x1-bsX/2,y1-bsY/2,z1-bsZ/2);
    box(bsX);
    popMatrix();
    
    if(i!=0){
      float x2 = -pts.get(i-1).x+bsX/2;
      float y2 = -pts.get(i-1).y+bsY/2;
      float z2 = -pts.get(i-1).z+bsZ/2;
      
      beginShape(QUAD_STRIP);
      vertex(x1,y1,z1);
      vertex(x2,y2,z2);
      vertex(x1-bsX,y1,z1);
      vertex(x2-bsX,y2,z2);
      vertex(x1-bsX,y1-bsY,z1);
      vertex(x2-bsX,y2-bsY,z2);
      vertex(x1,y1-bsY,z1);
      vertex(x2,y2-bsY,z2);
      vertex(x1,y1,z1);
      vertex(x2,y2,z2);
      endShape(CLOSE);
      
      beginShape(QUAD_STRIP);
      vertex(x1,y1,z1-bsZ);
      vertex(x2,y2,z2-bsZ);
      vertex(x1-bsX,y1,z1-bsZ);
      vertex(x2-bsX,y2,z2-bsZ);
      vertex(x1-bsX,y1-bsY,z1-bsZ);
      vertex(x2-bsX,y2-bsY,z2-bsZ);
      vertex(x1,y1-bsY,z1-bsZ);
      vertex(x2,y2-bsY,z2-bsZ);
      vertex(x1,y1,z1-bsZ);
      vertex(x2,y2,z2-bsZ);
      endShape(CLOSE);
      
      beginShape();
      vertex(x1,y1,z1);
      vertex(x2,y2,z2);
      vertex(x2,y2,z2-bsZ);
      vertex(x1,y1,z1-bsZ);
      endShape(CLOSE);
      beginShape();
      vertex(x1-bsX,y1,z1);
      vertex(x2-bsX,y2,z2);
      vertex(x2-bsX,y2,z2-bsZ);
      vertex(x1-bsX,y1,z1-bsZ);
      endShape(CLOSE);
      beginShape();
      vertex(x1,y1-bsY,z1);
      vertex(x2,y2-bsY,z2);
      vertex(x2,y2-bsY,z2-bsZ);
      vertex(x1,y1-bsY,z1-bsZ);
      endShape(CLOSE);
      beginShape();
      vertex(x1-bsX,y1-bsY,z1);
      vertex(x2-bsX,y2-bsY,z2);
      vertex(x2-bsX,y2-bsY,z2-bsZ);
      vertex(x1-bsX,y1-bsY,z1-bsZ);
      endShape(CLOSE);
    }
  }
  
  void drawCube(int i){
    if(i==1){
      PVector p0 = pts.get(0).copy();
      PVector p1 = pts.get(1).copy();
      float dx = p0.x-p1.x;
      float dy = p0.y-p1.y;
      float dz = p0.z-p1.z;
      widths[0] = dx;
      widths[1] = dy;
      widths[2] = dz;
      pushMatrix();
      translate(-p0.x+dx/2,-p0.y+dy/2,-p0.z+dz/2);
      fill(thisCol);
      box(abs(widths[0]),abs(widths[1]),abs(widths[2]));
      popMatrix();
    }
    if(pts.size()==1){
      PVector p0 = pts.get(0).copy();
      pushMatrix();
      translate(-p0.x,-p0.y,-p0.z);
      fill(thisCol);
      box(widths[0],widths[1],widths[2]);
      popMatrix();
    }
  }
  
  Line copy(){
    Line l = new Line(widths[0],widths[1],widths[2],thisCol);
    for(PVector p : this.pts){
      l.pts.add(new PVector(p.x,p.y,p.z));
    }
    if(isCube)l.isCube=true;
    return l;
  }
  
  void reset(){
    this.pts.clear();
    this.widths[0]=lineWeight;
    this.widths[1]=lineWeight;
    this.widths[2]=lineWeight;
    thisCol=lineCol;
    isCube=false;
  }
}