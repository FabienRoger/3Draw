int smoothness = 10;

PVector calcPoint(PVector best1, PVector best2){
   float angleCam1 = -toAngle(openingAngle1,resX,best1.x)-xRotDec1;
   float angleCam2 = toAngle(openingAngle2,resX,best2.x)+xRotDec2;
   float distance = getDistance(angleCam1,angleCam2);
   float x = distance*sin(radians(angleCam1));
   float y = distance*cos(radians(angleCam1));
   float zAngle = toAngle(verticalOpeningAngle1,resY,best1.y)+yRotDec1;
   float z = tan(radians(zAngle))*y;
   z-=camHeight;
   //y = map(y,300,1000,0,500);
   x-=d/2;
   //x*=2;
   //x = map(x,0,300,-500,500);
   //z = map(z,-300,300,-300,300);
   //println(best1+"   "+best2);
   //println(x+" "+y+" "+z);
   return smooth(new PVector(x,y,z));
}

float toAngle(float opA,float res,float pos){
  float relPos = pos - res/2;
  return map(relPos,-res/2,res/2,-opA/2,opA/2);
}


float getDistance(float angleCam1,float angleCam2){
  return d*cos(radians(angleCam2))/sin(radians(angleCam1+angleCam2));
}

PVector smooth(PVector newV){
  if(points.size()>=smoothness){
    PVector[]vecs = new PVector[smoothness+1];
    float[] weights = new float[smoothness+1];
    for(int i = 0; i<smoothness;i++){
      weights[i]=1;
      vecs[i]=points.get(points.size()-i-1);
    }
    vecs[smoothness]=newV;
    weights[smoothness]=1;
    return average(vecs,weights);
  }else{
    return newV;
  }
}

PVector average(PVector[] vecs,float[] weights){
  float x= 0;
  float y = 0;
  float z = 0;
  float weightsSum = 0;
  for(int i = 0; i<vecs.length;i++){
    x+=vecs[i].x*weights[i];
    z+=vecs[i].z*weights[i];
    y+=vecs[i].y*weights[i];
    weightsSum+=weights[i];
  }
  x/=weightsSum;
  y/=weightsSum;
  z/=weightsSum;
  return new PVector(x,y,z);
}

PVector calcOrtho(PVector v, PVector cv){
  PVector r = cv.copy();
  float dx = v.x-cv.x;
  float dy = v.y-cv.y;
  float dz = v.z-cv.z;
  int m = whichIsMax(dx,dy,dz);
  if(m==0){
    r.x=v.x;
  }
  if(m==1){
    r.y=v.y;
  }
  if(m==2){
    r.z=v.z;
  }
  return r;
}

int whichIsMax(float dx, float dy, float dz){
  if(abs(dx)>=abs(dy)&&abs(dx)>=abs(dz))return 0;
  if(abs(dy)>=abs(dx)&&abs(dy)>=abs(dz))return 1;
  if(abs(dz)>=abs(dy)&&abs(dz)>=abs(dx))return 2;
  println("BUG ORTHO");
  return -1;
}