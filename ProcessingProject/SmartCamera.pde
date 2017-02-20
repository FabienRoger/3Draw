int minPix = 6;
int threshold = 26;
  
class SmartCamera extends Capture{
  boolean fake;
  
  PVector pos;
  
  //static public SmartCamera createCam(computer_vision_v3 cv,int resX, int resY, String camName,int frameRefreshRate,PVector pos){
  //  return new SmartCamera(cv,resX, resY,camName,frameRefreshRate,pos);
  //}
  
  SmartCamera(ThreeDraw td,int resX, int resY, String camName,int frameRefreshRate,PVector pos){
    super(td,resX,resY,camName,frameRefreshRate);
    this.pos=pos;
    this.start();
    this.getBestPixel(0);
  }
  public PVector getBestPixel(int trackColor){
    color trackCol = trackColor;
    int bX=-1;
    int bY=-1;
    
    long avX = 0;
    long avY = 0;
    int pixNb = 0;
    this.loadPixels();
    //PVector recordLoc = new PVector(0,0);
    //float record = 1000;
    noStroke();
    for(int i = 0;i<this.width;i++){
      for(int j = 0;j<this.height;j++){
        int loc = i+j*this.width;
        color actCol = this.pixels[loc];
        float d = dist(red(actCol),green(actCol),blue(actCol),
          red(trackCol),green(trackCol),blue(trackCol));
        /*
        if(d<record){
          record = d;
          recordLoc = new PVector(i,j);
        }*/
        if(d<threshold){
          fill(trackCol);
          if(showVideo){
            rect(pos.x+i,pos.y+j,1,1);
          }
          avX+=i;
          avY+=j;
          pixNb++;
        }
         
      }
    }
    
    if(minPix<pixNb){
      avX/=pixNb;
      avY/=pixNb;
      bX=(int)avX;
      bY=(int)avY;
    }
    return new PVector(bX,bY);
  }
  
  void showBest(PVector best){
  stroke(255,0,0);
  strokeWeight(5);
   if(best.x!=-1){
     line(this.pos.x+best.x-10,this.pos.y+best.y,this.pos.x+best.x+10,this.pos.y+best.y);
     line(this.pos.x+best.x,this.pos.y+best.y-10,this.pos.x+best.x,this.pos.y+best.y+10);
   }
  }
  
  
}