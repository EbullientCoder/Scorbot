/*SCORBOT
Auriemma Valerio (0281266)
Andrea Lapiana (0279544)
Matteo Fresolone (0270299)
*/

//Coordinate Base
float xBase;
float yBase;

//Dimensioni Robot
//Dimensioni Link 0
float L0_x = 75;
float L0_y = 37.5;
float L0_z = 75;

//Dimensioni Link 1
float L1_x = 75;
float L1_y = 37.5;
float L1_z = 75;

//Dimensioni Giunto 2
float G2_x = 30;
float G2_y = 30;
float G2_z = 35;

//Dimensioni Link 2
float L2_x = 150;
float L2_y = 25;
float L2_z = 25;

//Dimensioni Giunto 3
float G3_x = 30;
float G3_y = 30;
float G3_z = 35;

//Dimensioni Link 3
float L3_x = 150;
float L3_y = 25;
float L3_z = 25;

//Dimensioni Giunto 4
float G4_x = 30;
float G4_y = 30;
float G4_z = 35;

//Dimensioni Link 4
float L4_x = 150;
float L4_y = 25;
float L4_z = 25;

//Dimensioni Pinza
int lato = 30;
int lp = 15;
float profondita = 15;

//Coordinate e orientamento iniziali
float xDes = 0;
float yDes = -300;
float zDes = 120;
//Braccio in avanti
float betaDes = 0;  
float omegaDes = 0;  
//Braccio indietro
float betaDesI = 0;
float omegaDesI = 0;

//Angoli Desiderati
float theta1Des;
float theta2Des;
float theta3Des;
float theta4Des;
float theta5Des;
//Calcolo Angoli
float cos1;
float sen1;
float cos3;
float sen3;
float argcos3;
float A1;
float A2;

//Controllo
float kp = 0.5;

//Errore massimo consentito tra Angolo Finale e Angolo Desiderato
float errore = 0;

//Variabili di Lavoro
float[] theta = {0, 0, 0, 0, 0};
float gomito = 1;
float indietro = 0;
float d1;
float d5;
int ngA;
int ngI;

//Matrice di Rotazione R05
float r11;
float r12;
float r13;
float r21;
float r22;
float r23;
float r31;
float r32;
float r33;

//Pinza
float theta5 = 0;

//Camera
float camera = 0;


void setup(){
  size(1000, 800, P3D);
  stroke(255);
  strokeWeight(2);
  
  xBase = width/2;
  yBase = height/2 + 200;
}

void draw(){
  background(255,255,255);
  lights();
  camera((width/2.0), height/2 - camera, (height/2.0) / tan(PI * 60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);
  
  //Disegno SCORBOT
  pushMatrix();
    robot(xBase, yBase);
  popMatrix();
  
  if(mousePressed){
    xBase = mouseX;
    yBase = mouseY;
  }
  
  if(keyPressed){
    //Movimento Camera
    if(keyCode == DOWN) camera -= 5;
    if(keyCode == UP) camera += 5;
    
    //Soluzioni Gomito
    if(keyCode == LEFT) gomito = -1;
    if(keyCode == RIGHT) gomito = 1;
    
    //Posizione
    if(key == 'x') xDes--;
    if(key == 'X') xDes++;
    if(key == 'y') yDes--;
    if(key == 'Y') yDes++;
    if(key == 'z') zDes--;
    if(key == 'Z') zDes++;
    
    //Angoli
    if(key == 'b') betaDes -= 0.1;
    if(key == 'B') betaDes += 0.1;
    if(key == 'w') omegaDes -= 0.1;
    if(key == 'W') omegaDes += 0.1;
    if(key == 'p') if(theta5 <= 0.3) theta5 += 0.01;
    if(key == 'P') if(theta5 >= -0.3) theta5 -= 0.01;
    
    //Lavoro
    if(key == 'a' || key == 'A') indietro = 0;
    if(key == 'i' || key == 'I') indietro = 1;
  }
  
  //Calcolo Angoli
  cinematicaInversa(yDes, -xDes, zDes);
 
 
  
  //Matrice R05
  r11 = cos(theta[0]) * cos(theta[1] + theta[2] + theta[3]) * cos(theta[4]) + sin(theta[0]) * sin(theta[4]);
  r12 = -cos(theta[0]) * cos(theta[1] + theta[2] + theta[3]) * sin(theta[4]) + sin(theta[0]) * cos(theta[4]);
  r13 = -cos(theta[0]) * sin(theta[1] + theta[2] + theta[3]);
  r21 = sin(theta[0]) * cos(theta[1] + theta[2] + theta[3]) * cos(theta[4]) - cos(theta[0]) * sin(theta[4]);
  r22 = -sin(theta[0]) * cos(theta[1] + theta[2] + theta[3]) * sin(theta[4]) - cos(theta[0]) * cos(theta[4]);
  r23 = -sin(theta[0]) * sin(theta[1] + theta[2] + theta[3]);
  r31 = -sin(theta[1] + theta[2] + theta[3]) * cos(theta[4]);
  r32 = sin(theta[1] + theta[2] + theta[3]) * sin(theta[4]);
  r33 = -cos(theta[1] + theta[2] + theta[3]);
  
  //Testo
  textSize(15);
  fill(0);
  
  //Comandi
  text("COMANDI:", 900, 200);
  text("DOWN: camera -= 5", 870, 225);
  text("UP: camera += 5", 870, 245);
  text("x: xDes --", 870, 265);
  text("X: xDes ++", 870, 285);
  text("y: yDes --", 870, 305);
  text("Y: yDes ++", 870, 325);
  text("z: zDes --", 870, 345);
  text("Z: zDes ++", 870, 365);
  text("b: betaDes --", 870, 385);
  text("B: betaDes ++", 870, 405);
  text("w: omegaDes --", 870, 425);
  text("W: omegaDes ++", 870, 445);
  text("p: thetaDes --", 870, 465);
  text("P: thetaDes ++", 870, 485);
  text("LEFT: Gomito Basso", 870, 505);
  text("RIGHT: Gomito Alto", 870, 525);
  text("a || A: Lavoro avanti", 870, 545);
  text("i || I: Lavoro indietro", 870, 565);
  
  //Coordinate
  text("COORDINATE:", 20, 20);
  text("xDes: ", 10, 40);
  text(xDes, 80, 40);
  text("yDes: ", 10, 60);
  text(yDes, 80, 60);
  text("zDes: ", 10, 80);
  text(zDes, 80, 80);
  text("betaDes: ", 10, 100);
  text(degrees(betaDes) % 360, 80, 100);
  text("omegaDes: ", 10, 120);
  text(degrees(omegaDes) % 360, 90, 120);
  
  //Matrice di Rotazione
  text("MATRICE R05:", 450, 20);
  text("_", 395, 30);
  text("|\n", 394, 45);
  text(r11, 403, 50);
  text(r12, 473, 50);
  text(r13, 543, 50);
  text("|\n", 587, 45);
  text("_", 582, 30);
  
  text("|\n", 394, 60);
  text(r21, 403, 70);
  text(r22, 473, 70);
  text(r23, 543, 70);
  text("|\n", 587, 60);
  
  text("|\n", 394, 75);
  text(r31, 403, 90);
  text(r32, 473, 90);
  text(r33, 543, 90);
  text("|\n", 587, 75);
  
  text("|\n", 394, 90);
  text("_", 395, 93);
  text("|\n", 587, 90);
  text("_", 582, 93);
  
  //Angoli
  text("ANGOLI:", 910, 20);
  text("Theta1: ", 870, 40);
  text(degrees(theta[0]) % 360, 940, 40);
  text("Theta2: ", 870, 60);
  text(degrees(theta[1]) % 360, 940, 60);
  text("Theta3: ", 870, 80);
  text(degrees(theta[2]) % 360, 940, 80);
  text("Theta4: ", 870, 100);
  text(degrees(theta[3]) % 360, 940, 100);
  text("Theta5: ", 870, 120);
  text(degrees(theta[4]) % 360, 940, 120);
 
  
}
  
  
 
//Metodo che si occupa di trovare la Cinematica Inversa
void cinematicaInversa(float x, float y, float z){
  
   if(gomito == 1) text("SOLUZIONE: GOMITO ALTO\n", width/2 - 100, 740);
   else text("SOLUZIONE: GOMITO BASSO\n", width/2 - 100, 740);
  
   if(indietro == 0){
        text("SOLUZIONE: BRACCIO AVANTI\n", width/2 - 100, 770);
        //Theta 1: Rotazione Base
        theta1Des = atan2(y, x) + ngA * 2 * PI;
    
    
        if(abs(theta[0] - theta1Des) > abs(theta[0] - (theta1Des + 2 * PI))){
            theta1Des += 2*PI;
            ngA++;
        }
        if(abs(theta[0] - theta1Des) > abs(theta[0] - (theta1Des - 2 * PI))){
            theta1Des -= 2 * PI;
            ngA--;
        }
        if(abs(theta[0] - theta1Des) > errore) theta[0] += kp * (theta1Des - theta[0]);
    
    
        //Theta 3: Terzo Giunto
        cos1 = cos(theta1Des);
        sen1 = sin(theta1Des);
    
        d1 = 2 * L0_y + G2_y/2;
        d5 = L4_x + lato/2 + lp + lato;
        A1 = x * cos1 + y * sen1 - (L1_x - G2_x)/2 - (L4_x + lato/2 + lp + lato) * cos(betaDes);
        A2 = d1 - z - d5 * sin(betaDes);
    
        argcos3 = (pow(A1, 2) + pow(A2, 2) - pow(L2_x, 2) - pow(L3_x, 2)) / (2 * L2_x * L3_x);
        if(abs(argcos3) <= 1){
            theta3Des = gomito * acos(argcos3);
      
            cos3 = cos(theta3Des);
            sen3 = sin(theta3Des);
      
            if(abs(theta[2] - theta3Des) >= 0) theta[2] += kp * (theta3Des - theta[2]);
        }
        else{
            textSize(25);
            fill(255, 0, 0);
            text("PUNTO NON RAGGIUNGIBILE\n", width/2 - 150, 350);
        }
    
    
        //Theta 2: Secondo Giunto
        theta2Des = atan2((L2_x + L3_x * cos3) * A2 - L3_x * sen3 * A1, (L2_x + L3_x * cos3) * A1 + L3_x * sen3 * A2) + ngI * 2 * PI;
        if(abs(theta[1] - theta2Des) > abs(theta[1] - (theta2Des + 2 * PI))){
            theta2Des += 2 * PI;
            ngI++;
        }
        if(abs(theta[1] - theta2Des) > abs(theta[1] - (theta2Des - 2 * PI))){
            theta2Des -= 2 * PI;
            ngI--;
        }
        if(abs(theta[1] - theta2Des) > errore) theta[1] += kp * (theta2Des - theta[1]);
    
    
        //Theta 4: Quarto Giunto
        theta4Des = betaDes - theta[1] - theta[2] - PI/2;
        if(abs(theta[3] - theta4Des) > errore) theta[3] += kp * (theta4Des - theta[3]);
    
    
        //Theta 5: Quinto Giunto
        theta5Des = omegaDes;
        if(abs(theta[4] - theta5Des) > errore) theta[4] += kp * (theta5Des - theta[4]);
   }
   else{
     //Soluzione Braccio indietro
     text("SOLUZIONE: BRACCIO INDIETRO\n", width/2 - 100, 770);
     
     betaDesI = betaDes + PI;
     omegaDesI = omegaDes + PI;
     
      //Theta 1: Rotazione Base
        theta1Des = atan2(y, x) + ngA * 2 * PI + PI;
    
    
        if(abs(theta[0] - theta1Des) > abs(theta[0] - (theta1Des + 2 * PI))){
            theta1Des += 2*PI;
            ngA++;
        }
        if(abs(theta[0] - theta1Des) > abs(theta[0] - (theta1Des - 2 * PI))){
            theta1Des -= 2 * PI;
            ngA--;
        }
        if(abs(theta[0] - theta1Des) > errore) theta[0] += kp * (theta1Des - theta[0]);
    
    
        //Theta 3: Terzo Giunto
        cos1 = cos(theta1Des);
        sen1 = sin(theta1Des);
    
        d1 = 2 * L0_y + G2_y/2;
        d5 = L4_x + lato/2 + lp + lato;
        A1 = x * cos1 + y * sen1 - (L1_x - G2_x)/2 - (L4_x + lato/2 + lp + lato) * cos(betaDesI);
        A2 = d1 - z - d5 * sin(betaDesI);
    
        argcos3 = (pow(A1, 2) + pow(A2, 2) - pow(L2_x, 2) - pow(L3_x, 2)) / (2 * L2_x * L3_x);
        if(abs(argcos3) <= 1){
            theta3Des = gomito * acos(argcos3);
      
            cos3 = cos(theta3Des);
            sen3 = sin(theta3Des);
      
            if(abs(theta[2] - theta3Des) >= 0) theta[2] += kp * (theta3Des - theta[2]);
        }
        else{
            textSize(25);
            fill(255, 0, 0);
            text("PUNTO NON RAGGIUNGIBILE\n", width/2 - 150, 350);
        }
    
    
        //Theta 2: Secondo Giunto
        theta2Des = atan2((L2_x + L3_x * cos3) * A2 - L3_x * sen3 * A1, (L2_x + L3_x * cos3) * A1 + L3_x * sen3 * A2) + ngI * 2 * PI;
        if(abs(theta[1] - theta2Des) > abs(theta[1] - (theta2Des + 2 * PI))){
            theta2Des += 2 * PI;
            ngI++;
        }
        if(abs(theta[1] - theta2Des) > abs(theta[1] - (theta2Des - 2 * PI))){
            theta2Des -= 2 * PI;
            ngI--;
        }
        if(abs(theta[1] - theta2Des) > errore) theta[1] += kp * (theta2Des - theta[1]);
    
    
        //Theta 4: Quarto Giunto
        theta4Des = betaDesI - theta[1] - theta[2] - PI/2;
        if(abs(theta[3] - theta4Des) > errore) theta[3] += kp * (theta4Des - theta[3]);
    
    
        //Theta 5: Quinto Giunto
        theta5Des = omegaDesI;
        if(abs(theta[4] - theta5Des) > errore) theta[4] += kp * (theta5Des - theta[4]);
   }
}

//Metodo che si occupa di disegnare il robot
void robot(float x, float y){ 
  //Disegno SR Base dello SCORBOT asse Z0
  fill(255, 0, 0);
  rect(xBase, yBase +25, 5, -150);
  text("z0", xBase, yBase - 140);
  
  //Disegno SR Base dello SCORBOT asse Y0
  fill(0, 255, 0);
  rect(xBase, yBase + 25, 150, 5);
  text("y0", xBase + 160, yBase+20);
  
  //Disegno SR Base dello SCORBOT asse X0
  fill(0, 0, 255);
  pushMatrix();
    translate(xBase, yBase, 0);
    rotateY(-PI/2);
    rect(0, 25, 150, 5);
    text("x0", 160, 20);
  popMatrix();
  
  fill(255);
  stroke(2);
  
  //Link 0
  fill(0,145,110);
  translate(x, y+5, 0);
  box(L0_x, L0_y, L0_z);
  
  //Giunto 1
  fill(165,16,45);
  rotateY(theta[0]);
  //Link 1
  translate(0, - L0_y, 0);
  box(L1_x, L1_y, L1_z);
  
  pushMatrix();
    //Giunto 2
    fill(165,16,45);
    translate(L1_x/2, -L1_y+4 , 0);
    box(G2_x, G2_y, G2_z);
    rotateZ(theta[1]);
    //Link 2
    fill(18,38,32);
    translate(3 * G2_x - 5, 0, 0);
    box(L2_x, L2_y, L2_z);
    translate(L3_x/2 + G3_x/2, 0, 0);
  
    //Giunto 3
    fill(165,16,45);
    box(G3_x, G3_y, G3_z);
    rotateZ(theta[2]);
    //Link 3
    fill(18,38,32);
    translate(L2_x/2 , 0, 0);
    box(L3_x, L3_y, L3_z);
  
    //Giunto 4
    fill(165,16,45);
    translate((L3_x + G4_x)/2, 0, 0);
    box(G4_x, G4_y, G4_z);
    rotateZ(PI/2 + theta[3]);
    //Link 4
    fill(18,38,32);
    translate((-G4_x + L4_x)/2, 0, 0);
    box(L4_x, L4_y, L4_z);
  
    //Giunto 5
    rotateX(theta[4]);
    //Link 5 - Pinza
    translate(L4_x/2 - 13, L4_y -8, profondita/2);
    rotateZ(-PI/2);
    pinza(0, 0, 0);
  
    //Disegno SR Pinza SCORBOT asse z5
    pushMatrix();
      fill(255, 0, 0);
      rotateZ(PI/2);
      rect(lato + (lato + lp)/2, 0, 90, 5);
      text("z5", 150, 0);
    popMatrix();
  
    //Disegno SR Pinza SCORBOT asse y5
    pushMatrix();
      fill(0, 255, 0);
      rect(0, (lato + (lato + lp)/2), -90, 5);
      text("y5", -110, (lato + (lato + lp)/2));
    popMatrix();
  
    //Disegno SR Pinza SCORBOT asse x5
    pushMatrix();
      fill(0, 0, 255);
      rotateY(PI/2);
      rect(0, (lato + (lato + lp)/2), -90, 5);
      text("x5", -110, (lato + (lato + lp)/2));
    popMatrix();
   
  popMatrix();
}


void pinza(float xP, float yP, float zP){
 fill(222,167,84);
 fill(165,16,45);
 translate(2 + xP + lato/2, yP + lato/2, zP - profondita/2);
 box(lato, lp, profondita);
  
 
    pushMatrix();
    translate(-lato/2, lp/2, profondita/2);
    
      //Pinza
      rotateZ(theta5);
      
      
      fill(165,16,45);
      //Faccia Leterale DX
      beginShape();  
        vertex(lp, 0, 0);
        vertex(lp, 0, -profondita);
        vertex(0, lato/2, -profondita);
        vertex(0, lato/2, 0);
      endShape(CLOSE);
      
      //Faccia Laterale SX
      beginShape();
        vertex(0, 0, 0);
        vertex(-lp, lato/2, 0);
        vertex(-lp, lato/2, -profondita);
        vertex(0, 0, -profondita);
      endShape(CLOSE);
 
      //Faccia Posteriore
      beginShape();
        vertex(0, 0, -profondita);
        vertex(lp, 0, -profondita);
        vertex(0, lato/2, -profondita);
        vertex(-lp, lato/2, -profondita);
      endShape(CLOSE);
      
      beginShape();
        vertex(0 , 0, 0);
        vertex(lp, 0, 0);
        vertex(0, lato/2, 0);
        vertex(-lp, lato/2, 0);
      endShape(CLOSE);
      
      //Punta SX
      translate(-lp, lato/2, 0);
      
      beginShape();
        vertex(0, 0, 0);
        vertex(lp, 0, 0);
        vertex(lp, lato, 0);
      endShape(CLOSE);
      
      
      //Faccia Laterale SINISTRA (597) 
      beginShape();
        vertex(0, 0, -profondita);
        vertex(lp, 0, -profondita);
        vertex(lp, lato, -profondita);
      endShape(CLOSE);
      
      //Faccia Laterale DX 
      beginShape();
        vertex(0, 0, 0);
        vertex(0, 0, -profondita);
        vertex(lp, lato, -profondita);
        vertex(lp, lato, 0);
      endShape(CLOSE);
      
       beginShape();
        vertex(lp, 0, 0);
        vertex(lp, 0, -profondita);
        vertex(lp, lato, -profondita);
        vertex(lp, lato, 0);
      endShape(CLOSE);
      
      
      popMatrix();
      
      pushMatrix();
      
      
      translate(lato/2, lp/2, profondita/2);
      //Pinza
      rotateZ(-theta5);
      
      beginShape();
        vertex(0, 0, -profondita);
        vertex(-lp, 0, -profondita);
        vertex(0, lato/2, -profondita);
        vertex(lp, lato/2, -profondita);
      endShape(CLOSE);
      
       beginShape(); 
        vertex(0 , 0, 0);
        vertex(-lp, 0, 0);
        vertex(0, lato/2, 0);
        vertex(lp, lato/2, 0);
      endShape(CLOSE);
      
      //Faccia Laterale DX
      beginShape();
        vertex(0, 0, 0);
        vertex(0, 0, -profondita);
        vertex(lp, lato/2, -profondita);
        vertex(lp, lato/2, 0);
      endShape(CLOSE);
      
      //Faccia Laterale SX
      beginShape();
        vertex(-lp, 0, 0);
        vertex(-lp, 0, -profondita);
        vertex(0, lato/2,-profondita);
        vertex(0, lato/2, 0);
      endShape(CLOSE);
      
      
      translate(0, lato/2, 0);
      
      //Punta DX
      //Faccia Anteriore
      beginShape();
        vertex(0, 0, 0);
        vertex(0, lato, 0);
        vertex(lp, 0, 0);
      endShape(CLOSE);
      
      
     //Faccia Posteriore
      beginShape();
        vertex(0, 0, -profondita);
        vertex(0, lato, -profondita);
        vertex(lp, 0, -profondita);
      endShape(CLOSE);
      
      //Faccia Laterale SX
      beginShape();
        vertex(0, 0, 0);
        vertex(0, 0, -profondita);
        vertex(0, lato, -profondita);
        vertex(0, lato, 0);
      endShape(CLOSE);
      
     //Faccia Laterale DX
      beginShape();
        vertex(lp, 0, 0);
        vertex(lp, 0, -profondita);
        vertex(0, lato, -profondita);
        vertex(0, lato, 0);
      endShape(CLOSE);
      
      popMatrix();
}
