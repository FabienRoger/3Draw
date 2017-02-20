ArrayList<String> toS = new ArrayList<String>();
void saveSTL(){
  toS.clear();
  toS.add("solid ProcessingSolid");
  for(Line l:lines){
    for(int i = 0;i<l.pts.size();i++){
      addCubeToSave(l.pts.get(i).x,l.pts.get(i).y,l.pts.get(i).z,l.widths[0]*wFRatio,l.widths[1]*wFRatio,l.widths[2]*wFRatio);
      if(i!=0){
        addLinkToSave(l.pts.get(i-1).x,l.pts.get(i-1).y,l.pts.get(i-1).z,l.pts.get(i).x,l.pts.get(i).y,l.pts.get(i).z,l.widths[0]*wFRatio,l.widths[1]*wFRatio,l.widths[2]*wFRatio);
      }
    }
  }
  toS.add("endsolid ProcessingSolid");
  
  String[] toSA = new String[toS.size()];
  for(int i = 0;i<toSA.length;i++){
    toSA[i] = toS.get(i);
  }
  try{
    saveStrings("ProcessingSolid.stl",toSA);
  }catch(Exception e){}
}

void addRectToSave(float x1,float y1,float z1,
                    float x2,float y2,float z2,
                    float x3,float y3,float z3,
                    float x4,float y4,float z4){ //ORDRE RECT TOUR
  toS.add("facet normal 0.0 0.0 0.0");
  toS.add("outer loop");
  toS.add("vertex "+(double)x1+" "+(double)-y1+" "+(double)-z1);
  toS.add("vertex "+(double)x2+" "+(double)-y2+" "+(double)-z2);
  toS.add("vertex "+(double)x3+" "+(double)-y3+" "+(double)-z3);
  toS.add("endloop");
  toS.add("endfacet");
  
  toS.add("facet normal 0.0 0.0 0.0");
  toS.add("outer loop");
  toS.add("vertex "+(double)x4+" "+(double)-y4+" "+(double)-z4);
  toS.add("vertex "+(double)x1+" "+(double)-y1+" "+(double)-z1);
  toS.add("vertex "+(double)x3+" "+(double)-y3+" "+(double)-z3);
  toS.add("endloop");
  toS.add("endfacet");
}

void addCubeToSave(float x,float y, float z, float bsX, float bsY, float bsZ){// CENTER CORD
  x-=bsX/2;
  z-=bsY/2;
  y-=bsZ/2;
  
  addRectToSave(x,y,z, x+bsX,y,z, x+bsX,y+bsY,z, x,y+bsY,z);
  addRectToSave(x,y,z, x,y+bsY,z, x,y+bsY,z+bsZ, x,y,z+bsZ);
  addRectToSave(x,y,z, x+bsX,y,z, x+bsX,y,z+bsZ, x,y,z+bsZ);
  addRectToSave(x+bsX,y+bsY,z+bsZ, x+bsX,y+bsY,z, x+bsX,y,z, x+bsX,y,z+bsZ);
  addRectToSave(x+bsX,y+bsY,z+bsZ, x+bsX,y,z+bsZ, x,y,z+bsZ, x,y+bsY,z+bsZ);
  addRectToSave(x+bsX,y+bsY,z+bsZ, x,y+bsY,z+bsZ, x,y+bsY,z, x+bsX,y+bsY,z);
}

void addLinkToSave(float x1,float y1, float z1, float x2,float y2, float z2, float bsX, float bsY, float bsZ){
  x1-=bsX/2;
  z1-=bsY/2;
  y1-=bsZ/2;
  x2-=bsX/2;
  z2-=bsY/2;
  y2-=bsZ/2;
  addRectToSave(x1,y1,z1, x1+bsX,y1,z1, x2+bsX,y2,z2, x2,y2,z2);
  addRectToSave(x1,y1,z1, x1,y1+bsY,z1, x2,y2+bsY,z2, x2,y2,z2);
  addRectToSave(x1,y1,z1, x1,y1,z1+bsZ, x2,y2,z2+bsZ, x2,y2,z2);
  
  addRectToSave(x1+bsX,y1,z1, x1+bsX,y1+bsY,z1, x2+bsX,y2+bsY,z2, x2+bsX,y2,z2);
  addRectToSave(x1+bsX,y1,z1, x1+bsX,y1,z1+bsZ, x2+bsX,y2,z2+bsZ, x2+bsX,y2,z2);
  
  addRectToSave(x1,y1+bsY,z1, x1,y1+bsY,z1+bsZ, x2,y2+bsY,z2+bsZ, x2,y2+bsY,z2);
  addRectToSave(x1,y1+bsY,z1, x1+bsX,y1+bsY,z1, x2+bsX,y2+bsY,z2, x2,y2+bsY,z2);
  
  addRectToSave(x1,y1,z1+bsZ, x1+bsX,y1,z1+bsZ, x2+bsX,y2,z2+bsZ, x2,y2,z2+bsZ);
  addRectToSave(x1,y1,z1+bsZ, x1,y1+bsY,z1+bsZ, x2,y2+bsY,z2+bsZ, x2,y2,z2+bsZ);
  
  addRectToSave(x1+bsX,y1+bsY,z1+bsZ, x1+bsX,y1+bsY,z1, x2+bsX,y2+bsY,z2, x2+bsX,y2+bsY,z2+bsZ);
  addRectToSave(x1+bsX,y1+bsY,z1+bsZ, x1+bsX,y1,z1+bsZ, x2+bsX,y2,z2+bsZ, x2+bsX,y2+bsY,z2+bsZ);
  addRectToSave(x1+bsX,y1+bsY,z1+bsZ, x1,y1+bsY,z1+bsZ, x2,y2+bsY,z2+bsZ, x2+bsX,y2+bsY,z2+bsZ);
}/*
beginShape(); 000 001 + 000 010 + 000 100 + 100 101 + 100 110 + 
      vertex(x1,y1,z1);
      vertex(x2,y2,z2);
      vertex(x2,y2,z2-bs);
      vertex(x1,y1,z1-bs);
      endShape(CLOSE);
      beginShape();
      vertex(x1-bs,y1,z1);
      vertex(x2-bs,y2,z2);
      vertex(x2-bs,y2,z2-bs);
      vertex(x1-bs,y1,z1-bs);
      endShape(CLOSE);
      beginShape();
      vertex(x1,y1-bs,z1);
      vertex(x2,y2-bs,z2);
      vertex(x2,y2-bs,z2-bs);
      vertex(x1,y1-bs,z1-bs);
      endShape(CLOSE);
      beginShape();
      vertex(x1-bs,y1-bs,z1);
      vertex(x2-bs,y2-bs,z2);
      vertex(x2-bs,y2-bs,z2-bs);
      vertex(x1-bs,y1-bs,z1-bs);
      endShape(CLOSE);*/