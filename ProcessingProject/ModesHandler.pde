int drawMode = 0;

final int NORMALD = 0;
final int ORTHONORMALD =  1;
final int STRAIGHTD =  2;
final int ORTHOSTRAIGHTD =  3;
final int CUBED =  4;
final int CTRLZD = 5;

String[] drawModes = new String[6];

void initModes(){
  drawModes[NORMALD]="Normal";
  drawModes[ORTHONORMALD]="Ortho-Normal";
  drawModes[STRAIGHTD]="Straight";
  drawModes[ORTHOSTRAIGHTD]="Orth-Straight";
  drawModes[CUBED]="Cube";
  drawModes[CTRLZD] = "Ctrl + z";
}

void incrementMode(){
  drawMode++;
  if(drawMode>=drawModes.length){
    drawMode=0;
  }
}