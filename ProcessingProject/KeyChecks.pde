int changeSpeed = 3;

void keyPressedCheck(){
  if(keyPressed){
    if(key=='z'){
      zPos+=200/frameRate;
    }
    if(key=='s'){
      zPos-=200/frameRate;
    }
    if(key=='e'){
      yPos+=500/frameRate;
    }
    if(key=='d'){
      yPos-=500/frameRate;
    }
    if(key=='a'){
      xPos+=200/frameRate;
    }
    if(key=='q'){
      xPos-=200/frameRate;
    }
  }
}

void keyPressed(){
  showVideo = false; 
  background(0);
  if(key==' '){
    drawEOn();
  }
  if(key=='c'){
    for(Line l:lines){
      l.pts.clear();
      sendList.add("CLEAR");
    }
    actLine.reset();
    isDrawing = false;
  }
  if(key=='v'){
    camera();
    showVideo=true;
  }
  if(key=='n'){
    changeModeE();
  }
  if(key=='p'){
    lineWeight+=changeSpeed;
  }
  if(key=='m'){
    lineWeight-=changeSpeed;
    if(lineWeight<=0)lineWeight=1;
  }
  if(key=='r'){
    lineCol=color(random(255),random(255),random(255));
  }
  if(key=='o'){
    optionE();
  }
  if(key=='l'){
    saveConfig();
  }
  if(key=='k'){
    readConfig();
  }
  if(key=='t'){
    saveSTL();
  }
  if(key=='h'){
    showVideo = true;
    helpActive = !helpActive;
  }
}

void keyReleased(){
  if(key==' '){
    drawEOff();
  }
  if(key=='n'){
    //nPressed=false;
  }
  if(key=='o'){
    //op.disable();
  }
}