#include <Wire.h>
#include <Keypad.h>
long valor = 0;
const byte ROWS =4;
const byte COLS = 4;
String cadena;
char keys[ROWS][COLS]={
  {'7','8','9','/'},
  {'4','5','6','*'},
  {'1','2','3','-'},
  {'c','0','b','+'}
  };

byte rowPins[ROWS] = {0,1,2,3};//pines de entrada columna calculadora
byte colPins[COLS] = {4,5,6,7};

Keypad keypad = Keypad(makeKeymap(keys),rowPins, colPins, ROWS, COLS);
void setup() {
  //inicializamos la comunicación i2c del maestro
  Wire.begin();
}

void loop() {
 delay(100); //milisegundos
 char key = keypad.getKey();
 cadena += (String)key;  
 //2012c
 if(key=='c' || key=='b'){
  char*envio = cadena.c_str();
  Wire.beginTransmission(1); //iniciamos la transmisión con el arduino esclavo, este arduino esclavo está conectado como canal 1 
  Wire.write(envio); //Escribimos el valor de la variable que funcionará para los motores
  Wire.endTransmission(); //se cierra la transmisión
  *envio =""; // se limpia las variables en enviar los datos
  cadena="";
  key="";
  }
 
 
 
}
