#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd2 (1,2,3,4,5,6);//Conexiones(rs,enable, d4,d5,d6,d7)
LiquidCrystal_I2C lcd(0x20,16,2);
char valorp; //valor 
String pass;
String getIgual;
bool banderaValidacion = false;
bool banderaTemp = false;
int temp=0;
int directionSensor=0x48;
int velocidadMotor1 = 0;
int velocidadMotor2 = 0;
void setup() {
  pinMode(8,OUTPUT);//PINES A UTILIZAR PARA EL MOTOR
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
  pinMode(12,OUTPUT);
  pinMode(13,OUTPUT);
  
lcd.init(); //inicio el lcd
lcd2.begin(16,2);
lcd2.setCursor(0,0);
lcd2.print("APAGADO");
Wire.begin(1); //Acá decimos que el esclavo se va a identificar con el # 1
Wire.onReceive(eventoRecepcion); //Función que se ejecuta cuando el arduino maestro incie la comunicación
Wire.beginTransmission(directionSensor);//se inicia la transmision del sensor
Wire.write(0xAC);//configuracion del sensor
Wire.write(0x02);
Wire.beginTransmission(directionSensor);
Wire.write(0xEE);
Wire.endTransmission();//se detiene la comunicacion del sensor

lcd.setCursor(0,0);
lcd.print("CASA ACYE1");
lcd.setCursor(0,1);
lcd.print("201801449-S2");
}

void eventoRecepcion(){
   while(Wire.available()){
    char data = Wire.read();
    if(data=='c'){
      banderaValidacion=true;
      data="";
      break;
     }else if(data=='b'){
       banderaTemp=false;
       break;
     }else{
        pass += (String)data;
      }
   }
    
}

void loop() {
 
  //iniciamos la comunicacion con el sensor
  Wire.beginTransmission(directionSensor);
  Wire.write(0xAA);
  Wire.endTransmission();
  Wire.requestFrom(directionSensor,1);//pedimos un byte al sensor
  temp = Wire.read();
  
 if(banderaValidacion==true){
    validacionPass();
    banderaValidacion=false;
    pass="";  
    }
  
  if(banderaTemp==true){
    validacionTemp();
   }else{
    lcd2.clear();
    lcd2.setCursor(0,0);
    lcd2.print("APAGADO");
    lcd.setCursor(0,0);
   
    velocidadMotor1 = 0; //ambos motores se apagan
    velocidadMotor2 = 0;
    movimientoMotor1();
    movimientoMotor2();   
   }
  
  delay(100);
 }

void movimientoMotor1(){
  analogWrite(10,velocidadMotor1); //habilita el motor 1
  digitalWrite(8,1);//gira el motor a la derecha
  digitalWrite(9,0); //gira el motor a la izquierda
  }

void movimientoMotor2(){
  analogWrite(11,velocidadMotor2); //habilita el motor 2
  digitalWrite(12,1);//gira el motor a la derecha
  digitalWrite(13,0); //gira el motor a la izquierda
  }
 void validacionTemp(){
  if(temp<18){ //temperatura menor a 18 grados
    lcd2.clear();
    lcd2.setCursor(0,0);
    lcd2.print("TEMP:");
    lcd2.print(temp);
    lcd2.print(" C");
    lcd2.setCursor(0,1);
    lcd2.print("NIVEL:1");
    velocidadMotor1 =0; // ambos motores apagados
    movimientoMotor1();
    
   }else if(temp>18 && temp<25){
    lcd2.clear();
    lcd2.setCursor(0,0);
    lcd2.print("TEMP:");
    lcd2.print(temp);
    lcd2.print(" C");
    lcd2.setCursor(0,1);
    lcd2.print("NIVEL:2");
    velocidadMotor1 =150;//solo un motor se enciende
    velocidadMotor2 =0;
    movimientoMotor1();
    movimientoMotor2();
    
   }else if(temp>=25){
    lcd2.clear();
    lcd2.setCursor(0,0);
    lcd2.print("TEMP:");
    lcd2.print(temp);
    lcd2.print(" C");
    lcd2.setCursor(0,1);
    lcd2.print("NIVEL:3"); 
    velocidadMotor1 = 150; //ambos motores se encienden
    velocidadMotor2 = 150;
    movimientoMotor1();
    movimientoMotor2();
   }
  }
 void validacionPass(){
  if(pass=="2021201801449"){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("BIENVENIDO A");
    lcd.setCursor(0,1);
    lcd.print("CASA");
    banderaTemp=true;
   }else{
     lcd.clear();
     lcd.setCursor(0,0);
     lcd.print("ERROR EN");
     lcd.setCursor(0,1);
     lcd.print("CONTRASENA");
      }
    
  }
