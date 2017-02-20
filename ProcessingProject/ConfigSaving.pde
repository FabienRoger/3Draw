
int version = 1;

String[] config = new String[24];

void readConfig(){
  String tConfig[]=loadStrings("config.txt");
  version = int(tConfig[0].split(": ")[1]);
  camName1 = tConfig[1].split(": ")[1];
  openingAngle1 = float(tConfig[2].split(": ")[1]);
  camName2 = tConfig[3].split(": ")[1];
  openingAngle2 = float(tConfig[4].split(": ")[1]);
  smoothness = int(tConfig[5].split(": ")[1]);
  trackCol1 = int(tConfig[6].split(": ")[1]);
  trackCol2 = int(tConfig[7].split(": ")[1]);
  camHeight = float(tConfig[8].split(": ")[1]);
  unityTransferEnable = (int(tConfig[9].split(": ")[1])==0?false:true);
  ledTrakingEnable = (int(tConfig[10].split(": ")[1])==0?false:true);
  totalSaveEnable = (int(tConfig[11].split(": ")[1])==0?false:true);
  camDrawLed = int(tConfig[12].split(": ")[1]);
  drawLedCol = int(tConfig[13].split(": ")[1]);
  camOptionLed = int(tConfig[14].split(": ")[1]);
  optionLedCol = int(tConfig[15].split(": ")[1]);
  xRotDec1 = float(tConfig[16].split(": ")[1]);
  xRotDec2 = float(tConfig[17].split(": ")[1]);
  yRotDec1 = float(tConfig[18].split(": ")[1]);
  yRotDec2 = float(tConfig[19].split(": ")[1]);
  d=float(tConfig[20].split(": ")[1]);
  threshold=int(tConfig[21].split(": ")[1]);
  minPix=int(tConfig[22].split(": ")[1]);
  decompileSavedLines(tConfig[23].split(": ")[1]);
}

void saveConfig(){
  config[0] = "version : "+version;
  config[1] = "camera name 1: "+camName1;
  config[2] = "angle cam 1: "+openingAngle1;
  config[3] = "camera name 2: "+camName2;
  config[4] = "angle cam 2: "+openingAngle2;
  config[5] = "smoothness (max = 50): "+smoothness;
  config[6] = "pref color cam 1: "+trackCol1;
  config[7] = "pref color cam 2: "+trackCol2;
  config[8] = "camera height: "+camHeight;
  config[9] = "unity save enable: "+(unityTransferEnable?1:0);
  config[10] = "led tracking enable: "+(ledTrakingEnable?1:0);//
  config[11] = "total save enable: "+(totalSaveEnable?1: 0);
  config[12] = "cam led col: "+camDrawLed;
  config[13] = "draw led col: "+drawLedCol;
  config[14] = "cam option col: "+camOptionLed;
  config[15] = "otpion led col: "+optionLedCol;
  config[16] = "offset around axis X, cam 1: "+xRotDec1;
  config[17] = "offset around axis X, cam 2: "+xRotDec2;
  config[18] = "offset around axis Y, cam 1: "+yRotDec1;
  config[19] = "offset around axis Y, cam 2: "+yRotDec2;
  config[20] = "distance btw cam1 and cam 2: "+d;
  config[21] = "threshold color dist: "+threshold;
  config[22] = "minimum pixel number to detect: "+minPix;
  config[23] = "saved lines: "+compileLines();
  saveStrings("config.txt",config);
}

void decompileSavedLines(String c){
  String[] tLines = c.split("t");
  for(int i = 1;i<tLines.length;i++){
    String[] tLineInfo = tLines[i].split(";");
    actLine.reset();
    //Line l =new Line(float(tLineInfo[0]),float(tLineInfo[1]),float(tLineInfo[2]),int(tLineInfo[3]));
    actLine.thisCol=int(tLineInfo[3]);
    actLine.widths[0] = float(tLineInfo[0]);
    actLine.widths[1] = float(tLineInfo[1]);
    actLine.widths[2] = float(tLineInfo[2]);
    if(actLine.widths[0]!=actLine.widths[1]&&actLine.widths[0]!=actLine.widths[2]&&actLine.widths[2]!=actLine.widths[1])actLine.isCube=true;
    for(int j = 4;j<tLineInfo.length;j++){
      String[] tPts = tLineInfo[j].split(",");
      actLine.addPt(float (tPts[0]),float (tPts[1]),float (tPts[2]));
    }
    addLine(actLine.copy());
    actLine.reset();
  }
  //println(lines.size());
}

String compileLines(){
  String r = "  ";
  for(Line l:lines){
    r+="t";
    r+=compileLine(l);
  }
  return r;
}

String compileLine(Line l){
  String r = "";
  r+=l.widths[0]+";";
  r+=l.widths[1]+";";
  r+=l.widths[2]+";";
  r+=l.thisCol+";";
  for(PVector p:l.pts){
    r+=p.x+","+p.y+","+p.z;
    r+=";";
  }
  r = r.substring(0, r.length()-1);
  return r;
}