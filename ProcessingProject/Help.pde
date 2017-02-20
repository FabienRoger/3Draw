boolean helpActive = false;
int marge = 20;
int spaceBtwLines = 25;
String[] helpStrings = {
  "right clic on the right picture to adjust the right camera's color target",
  "left clic on the left picture to adjust the left camera's color target",
  "press v to see the 3D drawings",
  "press the sapce bar to draw",
  "press z or s to move vertically",
  "press e or d to move forward or backward",
  "press a or q to rotate around the y axis",
  "press o to activate the option menu, repress o to select an option in the option menu",
  "press l to save your configuration",
  "press k to press the saved configuration (which is automaticly load at the lunch or the program)",
  "press p or m to change the drawing weight",
  "press n to change drawing mode",
  "go to the config file to more advanced options",
  "press h to escape help"
  
};

void showHelp(){
  stroke(255);
  fill(255,255,255,200);
  rect(marge,marge,width-2*marge,height-2*marge);
  fill(0);
  textSize(20);
  for(int i = 0;i<helpStrings.length;i++){
    text(helpStrings[i],marge+12,marge+(i+1)*spaceBtwLines);
  }
  textSize(12);
}