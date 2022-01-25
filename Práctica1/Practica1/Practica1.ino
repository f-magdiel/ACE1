#include <MD_Parola.h>
#include <MD_MAX72xx.h>
#include <SPI.h>
#include <MatrizLed.h>
#include "LedControl.h"
#define HARDWARE_TYPE MD_MAX72XX::FC16_HW
#define MAX_DEVICES 2
#define CS_PIN 12
#define DATA_PIN 13
#define CLK_PIN 11
MatrizLed pantalla;

LedControl lc = LedControl(DATA_PIN,CLK_PIN,CS_PIN,MAX_DEVICES); // creando un objeto de LedControl
MD_Parola myDisplay = MD_Parola(HARDWARE_TYPE, DATA_PIN, CLK_PIN, CS_PIN, MAX_DEVICES); // creando objeto de Parola

//ENTRADA DE PINES
const int entrada_1 = 14; // boton entrada 1
const int entrada_2 = 15; // boton entrada 2
const int entrada_start = 16;
const int entrada_play = 17;
const int entrada_alta = 18;
const int entrada_baja = 19;
const int up = 7 ;
const int down = 6;
const int left = 5;
const int right = 4;
int contadorComida = 0;

byte letra_t [8]={ //letra T en matriz
  B01111100,
  B00010000,
  B00010000,
  B00010000,
  B00010000,
  B00010000,
  B00010000,
  B00000000,
  };
  byte letra_p [8]={ //letra P en matriz
  B00111100,
  B00100010,
  B00100010,
  B00111100,
  B00100000,
  B00100000,
  B00100000,
  B00000000,
  };
  byte letra_1 [8]={ //letra 1 en matriz
  B00010000,
  B00110000,
  B00010000,
  B00010000,
  B00010000,
  B00010000,
  B00010000,
  B00000000,
  };

  byte letra_guion [8]={ //letra gion en matriz
  B00000000,
  B00000000,
  B00000000,
  B01111100,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  };

  byte letra_c [8]={ //letra C en matriz
  B00111000,
  B01000100,
  B01000000,
  B01000000,
  B01000000,
  B01000100,
  B00111000,
  B00000000,
  };

  byte letra_a [8]={ //letra A en matriz
  B00111000,
  B01000100,
  B01000100,
  B01111100,
  B01000100,
  B01000100,
  B01000100,
  B00000000,
  };

  byte letra_r [8]={ //letra R en matriz
  B01111000,
  B01000100,
  B01000100,
  B01111000,
  B01000100,
  B01000100,
  B01000100,
  B00000000,
  };

  byte letra_n [8]={ //letra N en matriz
  B01000100,
  B01000100,
  B01100100,
  B01010100,
  B01001100,
  B01000100,
  B01000100,
  B00000000,
  };

  byte letra_e [8]={ //letra E en matriz
  B01111100,
  B01000000,
  B01000000,
  B01111000,
  B01000000,
  B01000000,
  B01111100,
  B00000000,
  };

  byte letra_guionbajo [8]={ //letra guionbajo en matriz
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B01111100,
  B00000000,
  };

  byte letra_2 [8]={ //letra 2 en matriz
  B00111000,
  B01000100,
  B00000100,
  B00001000,
  B00010000,
  B00100000,
  B01111100,
  B00000000,
  };

  byte letra_0 [8]={ //letra 0 en matriz
  B00111000,
  B01000100,
  B01001100,
  B01010100,
  B01100100,
  B01000100,
  B00111000,
  B00000000,
  };

  byte letra_8 [8]={ //letra 8 en matriz
  B00111000,
  B01000100,
  B01000100,
  B00111000,
  B01000100,
  B01000100,
  B00111000,
  B00000000,
  };

  byte letra_4 [8]={ //letra 4 en matriz
  B01000100,
  B01000100,
  B01000100,
  B01111100,
  B00000100,
  B00000100,
  B00000100,
  B00000000,
  };

  byte letra_9 [8]={ //letra 9 en matriz
  B00111000,
  B01000100,
  B01000100,
  B00111100,
  B00000100,
  B01000100,
  B00111000,
  B00000000,
  };

  byte letra_3 [8]={ //letra  3 en matriz
  B00111000,
  B01000100,
  B00000100,
  B00011000,
  B00000100,
  B01000100,
  B00111000,
  B00000000,
  };
  
   byte letra_nada [8]={ //letra  NADA en matriz
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  };
 //declaracion de configuraciones
int opcion = 0;
long tiempoInicio = 0;
long tiempo2 = 0;
bool banderaInicio = false;
bool banderaPlay = false;
int opcionVelocidad = 1;
bool banderaGameOver = false;

//tamaño incial de la serpiente
const short initialSnakeLength = 2;

struct Point {
  int row = 0, col = 0;
  Point(int row = 0, int col = 0): row(row), col(col) {}
};

struct Coordinate {
  int x = 0, y = 0;
  Coordinate(int x = 0, int y = 0): x(x), y(y) {}
};

bool win = false;  //Gananar
bool gameOver = false; // Fin de juego

//coordenadas principales de la cabeza de la serpiente (cabeza de la serpiente), se generará aleatoriamente
Point snake;

// la comida aún no está en ninguna parte
Point food(-1, -1);

// parámetros de la serpiente
int snakeLength = initialSnakeLength; // elegido anteriormete en la sección de configuración
int snakeSpeed = 2000; //se configurará de acuerdo con el valor del nivel (4 Niveles), no puede ser 0 por defecto valor de 100
int snakeDirection = 0; // si es 0 la serpiente no se mueve.

// almacenamiento de segmentos de cuerpo de serpiente
int gameboard[8][16] = {};
String palabra = "TP1-CARNET_201801449";
String puntuacion;
char *strWord = palabra.c_str();

void setup() {
  pinMode(entrada_1,INPUT);
  pinMode(entrada_2,INPUT);
  pinMode(entrada_start,INPUT);
  pinMode(entrada_play,INPUT);
  pinMode(entrada_alta,INPUT);
  pinMode(entrada_baja,INPUT);
  
  lc.shutdown(1,false);
  lc.setIntensity(1,5);
  lc.clearDisplay(1);

  randomSeed(random(24,200));
  snake.row = random(8);
  snake.col = random(15);
  
  myDisplay.begin();
  myDisplay.setIntensity(5);
  myDisplay.displayClear();
  myDisplay.displayText(strWord,PA_LEFT,100,0,PA_SCROLL_LEFT,PA_SCROLL_LEFT);


}

void loop() {
  tiempoInicio = millis();
  
  if(banderaInicio == false){
     
    if(banderaGameOver==false){ //cuando sea falso
      entradas(); //función de los mensajes al principio
      inicio(); // configuracion al inicio
      banderaPlay = false;
      opcionVelocidad = 1;
      //banderaGameOver = true;
      }else{
         mensajeGameOver();
          //mensaje de game over + puntuacion
        }
    if(banderaGameOver == true && tiempoInicio - tiempo2 >=20000){
      tiempo2=tiempoInicio;
      banderaGameOver = false;
      myDisplay.displayClear();
      }
   
    
    }else if(banderaInicio == true){
     
     if(banderaPlay == true){ //condicion para el btn play 
      //se ejecuta el juego
        generateFood();    // si no hay comida, genera una
        scanJoystick();    // observa los movimientos del control y parpadea con la comida
        calculateSnake();  // calcula los parámetros de la serpiente
        handleGameStates(); //ve el estado del juego
        if(banderaGameOver == true){
          banderaPlay = false;
          banderaInicio = false;
          
        }
      }else if(banderaPlay==false){
        seleccionVelocidad();
        }
     
    }
    inicio();
    
}

void seleccionVelocidad(){
    int estadoAlta = digitalRead(entrada_alta);
    int estadoBaja = digitalRead(entrada_baja);
    int estadoPlay = digitalRead(entrada_play);

    //al presionar el btn de alta
    if(estadoAlta==HIGH){
      if(opcionVelocidad!=4){
        opcionVelocidad = opcionVelocidad + 1;
        }
      while(digitalRead(entrada_alta)==HIGH){
        //Nada
        }
      }
      //al presionar el btb de baja
      if(estadoBaja==HIGH){
        if(opcionVelocidad!=1){
          opcionVelocidad = opcionVelocidad - 1;
          }
        while(digitalRead(entrada_baja)==HIGH){
          //nada
          }
        }

        //escucha del btn play 
       if(estadoPlay==HIGH){
          banderaPlay = true;
          while(digitalRead(entrada_play)==HIGH){
            //nada
            }
        }

        //opcion para mostrar velocidad
        if(opcionVelocidad ==1){
          snakeSpeed = 2000;
            for (int i = 0;i<8;i++){
            lc.setRow(0,i,letra_0[i]);
            }
            for (int i = 0;i<8;i++){
            lc.setRow(1,i,letra_1[i]);
            }
            
          }else if(opcionVelocidad ==2){
            snakeSpeed = 1500;
            for (int i = 0;i<8;i++){
            lc.setRow(0,i,letra_0[i]);
            }
            for (int i = 0;i<8;i++){
            lc.setRow(1,i,letra_2[i]);
            }
          }else if(opcionVelocidad==3){
            snakeSpeed = 1000;
            for (int i = 0;i<8;i++){
            lc.setRow(0,i,letra_0[i]);
            }
            for (int i = 0;i<8;i++){
            lc.setRow(1,i,letra_3[i]);
            }
          }else if(opcionVelocidad==4){
            snakeSpeed = 500;
            for (int i = 0;i<8;i++){
            lc.setRow(0,i,letra_0[i]);
            }
            for (int i = 0;i<8;i++){
            lc.setRow(1,i,letra_4[i]);
            }
            }

         if(banderaPlay == true){
          for (int i = 0;i<8;i++){
            lc.setRow(1,i,letra_nada[i]);
            lc.setRow(0,i,letra_nada[i]);
          }
          }
  }

void inicio(){
 int estadobtn = digitalRead(entrada_start);

 if(estadobtn == HIGH){
  while(digitalRead(entrada_start)==HIGH && tiempoInicio-tiempo2 >= 3000){
    tiempo2=tiempoInicio;
    if(banderaInicio == false){
      banderaInicio = true;
      
    }else if (banderaInicio==true){
      banderaInicio = false;
     
      }
    }
  }

  
  

    
  }

void entradas(){
  palabra = "TP1-CARNET_201801449";
  int estado_entrada1 = digitalRead(entrada_1); //leyendo la entrada
  int estado_entrada2 = digitalRead(entrada_2); //leyendo la entrada

    
  if(estado_entrada1 == LOW && estado_entrada2 == LOW){ //movimiento de izquierda a derecha
    myDisplay.setTextEffect(PA_SCROLL_RIGHT,PA_SCROLL_RIGHT);
    int velocidad =400;
    int map_speed=map(velocidad,1023,0,400,15);
    myDisplay.setSpeed(map_speed);
    
  }else if(estado_entrada1 == LOW && estado_entrada2 == HIGH){ //movimiento de derecha a izquierda
     myDisplay.setTextEffect(PA_SCROLL_LEFT,PA_SCROLL_LEFT);
     int velocidad =100;
     int map_speed=map(velocidad,1023,0,400,15);
     myDisplay.setSpeed(map_speed);
  }else if(estado_entrada1 == HIGH && estado_entrada2 == LOW){ //sin movimiendo de izquierda a derecha
    letrasIzquierdaDerecha();
  }else if(estado_entrada1 == HIGH && estado_entrada2 == HIGH){//sin movimiento de derecha a izquierda
    letrasDerechaIzquierda();
    
    }
  
  if(myDisplay.displayAnimate()){
      myDisplay.displayReset();
    }
}

void mensajeGameOver(){
  
  palabra = "GAME OVER "+puntuacion;
  int estado_entrada1 = digitalRead(entrada_1); //leyendo la entrada
  int estado_entrada2 = digitalRead(entrada_2); //leyendo la entrada

    
  if(estado_entrada1 == LOW && estado_entrada2 == LOW){ //movimiento de izquierda a derecha
    myDisplay.setTextEffect(PA_SCROLL_RIGHT,PA_SCROLL_RIGHT);
    int velocidad =400;
    int map_speed=map(velocidad,1023,0,400,15);
    myDisplay.setSpeed(map_speed);
    
  }
  
  if(myDisplay.displayAnimate()){
      myDisplay.displayReset();
    }
}

void letrasIzquierdaDerecha(){
  //letra 9
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_9[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_9[i]);
  }
  delay(500);
  
  //letra 4
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_4[i]);
  }
  delay(500);
   for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_4[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_4[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_4[i]);
  }
  delay(500);

  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);

  //letra 0
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_0[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_0[i]);
  }
  delay(500);

  //letra 8
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_8[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_8[i]);
  }
  delay(500);

  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);
  
  //letra 8
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_0[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_0[i]);
  }
  delay(500);

  //letra 2
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_2[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_2[i]);
  }
  delay(500);

  //letra guionbajo
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_guionbajo[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_guionbajo[i]);
  }
  delay(500);

  //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_t[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_t[i]);
  }
  delay(500);

  //letra e
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_e[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_e[i]);
  }
  delay(500);

  //letra n
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_n[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_n[i]);
  }
  delay(500);

  //r
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_r[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_r[i]);
  }
  delay(500);

  //letra a
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_a[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_a[i]);
  }
  delay(500);
  
  //letra c
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_c[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_c[i]);
  }
  delay(500);

  //letra guion
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_guion[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_guion[i]);
  }
  delay(500);

  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);

  //letra p
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_p[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_p[i]);
  }
  delay(500);

  //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_t[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_t[i]);
  }
  delay(500);
  
  }

  void letrasDerechaIzquierda(){
    //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_t[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_t[i]);
  }
  delay(500);

  //letra p
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_p[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_p[i]);
  }
  delay(500);
  
  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);

  //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_guion[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_guion[i]);
  }
  delay(500);

  //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_c[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_c[i]);
  }
  delay(500);

  //letra a
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_a[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_a[i]);
  }
  delay(500);

  //letra r
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_r[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_r[i]);
  }
  delay(500);

  //letra n
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_n[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_n[i]);
  }
  delay(500);

  //letra e
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_e[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_e[i]);
  }
  delay(500);

  //letra t
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_t[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_t[i]);
  }
  delay(500);

  //letra guionbajo
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_guionbajo[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_guionbajo[i]);
  }
  delay(500);

  //letra 2
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_2[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_2[i]);
  }
  delay(500);

  //letra 0
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_0[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_0[i]);
  }
  delay(500);

  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);

//letra 8
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_8[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_8[i]);
  }
  delay(500);

  //letra 0
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_0[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_0[i]);
  }
  delay(500);


  //letra 1
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_1[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_1[i]);
  }
  delay(500);

  //letra 4
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_4[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_4[i]);
  }
  delay(500);

  //letra 4
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_4[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_4[i]);
  }
  delay(500);

  //letra 9
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_9[i]);
  }
  delay(500);
  for (int i = 0;i<8;i++){
      lc.setRow(1,i,letra_nada[i]);
  }
  for (int i = 0;i<8;i++){
      lc.setRow(0,i,letra_9[i]);
  }
  delay(500);

  
    }
// -------------------------- LOGICA DEL JUEGO -------------------------- //

// si no hay comida, genera una, también verifica la victoria
void generateFood() {
  if (food.row == -1 || food.col == -1) {
    
    if (snakeLength >= 128) { //valor donde se gana el juego las dos marices llenas :(
      win = true;
      return; //evitar que el generador de alimentos se ejecute, en este caso funcionaría para siempre, porque no podrá encontrar un píxel sin una serpiente
    }

    // generar alimento hasta que esté en la posición correcta
    do {
      food.col = random(15);
      food.row = random(8);
    } while (gameboard[food.row][food.col] > 0);
  }
}


// observa los movimientos del joystick y parpadea con la comida
void scanJoystick() {
  int previousDirection = snakeDirection; // guarda la ultima direccion
  long timestamp = millis();

  while (millis() < timestamp + snakeSpeed) {
    if (snakeSpeed == 0) snakeSpeed = 1; // safety: speed can not be 0

    // determina la direccion de la serpiente
    if ((digitalRead(left) == true) && (snakeDirection != right)) snakeDirection = left;
    if ((digitalRead(right) == true) && (snakeDirection != left)) snakeDirection = right;
    if ((digitalRead(up) == true) && (snakeDirection != down)) snakeDirection = up;
    if ((digitalRead(down) == true) && (snakeDirection != up)) snakeDirection = down;
 
    // parpadeo de la comida de la serpiente (dibujar comida)
    int colMatrix2 = caseM2(food.col);
    if(food.col > 7)lc.setLed(1, food.row, colMatrix2, millis() % 100 < 80 ? 1 : 0);
    else lc.setLed(0, food.row, food.col, millis() % 100 < 80 ? 1 : 0);
  }
}

//retorna el numero de columa para el encedido de led en la matriz 2
int caseM2(int col){
  switch(col){
    case 8: 
    return 0;
    break;
    case 9: 
    return 1;
    break;
    case 10: 
    return 2;
    break;
    case 11: 
    return 3;
    break;
    case 12: 
    return 4;
    break;
    case 13: 
    return 5;
    break;
    case 14: 
    return 6;
    break;
    case 15: 
    return 7;
    break;
  }
}


// calcular los movimientos 
void calculateSnake() {
  switch (snakeDirection) {
    case up:
      snake.row--;
      fixEdge();
      lc.setLed(0, snake.row, snake.col, 1);
      break;

    case right:
      snake.col++;
      fixEdge();
      lc.setLed(0, snake.row, snake.col, 1);
      break;

    case down:
      snake.row++;
      fixEdge();
      lc.setLed(0, snake.row, snake.col, 1);
      break;

    case left:
      snake.col--;
      fixEdge();
      lc.setLed(0, snake.row, snake.col, 1);
      break;

    default: // si la serpiente no se mueve se sale
      return;
  }

  // cuando la sepiente se toca asi misma (la serpiente debe estar en movimiento)
  if (gameboard[snake.row][snake.col] > 1 && snakeDirection != 0) {
    gameOver = true;
    return;
  }

  // comprobar si se comió la comida
  if (snake.row == food.row && snake.col == food.col) {
    food.row = -1; // resetear la comida
    food.col = -1;

    //contador de la comida del snake
    contadorComida++;
    
    // Incrementar la longitud de la serpiente y aumenta la velocidad
    snakeLength++;
    if(snakeLength == 5){
      if(opcionVelocidad == 1){
        snakeSpeed = 1000;
      }else if(opcionVelocidad==2){
        snakeSpeed = 1000;
      }else if(opcionVelocidad==3){
        snakeSpeed = 800;  
      }else if(opcionVelocidad == 4){
        snakeSpeed = 400;
      }
    }else if(snakeLength==10){
      if(opcionVelocidad == 1){
        snakeSpeed = 800;
      }else if(opcionVelocidad==2){
        snakeSpeed = 800;
      }else if(opcionVelocidad==3){
        snakeSpeed = 500;  
      }else if(opcionVelocidad == 4){
        snakeSpeed = 300;
      }  
    }else if(snakeLength==15){
      if(opcionVelocidad == 1){
        snakeSpeed = 500;
      }else if(opcionVelocidad==2){
        snakeSpeed = 500;
      }else if(opcionVelocidad==3){
        snakeSpeed = 300;  
      }else if(opcionVelocidad == 4){
        snakeSpeed = 200;
      }    
    }else if(snakeLength==20){
      if(opcionVelocidad == 1){
        snakeSpeed = 300;
      }else if(opcionVelocidad==2){
        snakeSpeed = 300;
      }else if(opcionVelocidad==3){
        snakeSpeed = 200;  
      }else if(opcionVelocidad == 4){
        snakeSpeed = 100;
      } 
    }

    // incrementa todos los segmentos del cuerpo de la serpiente
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 16; col++) {
        if (gameboard[row][col] > 0 ) {
          gameboard[row][col]++;
        }
      }
    }
  }

  // agregar un nuevo segmento en la ubicación de la cabeza de serpiente
  gameboard[snake.row][snake.col] = snakeLength + 1; // será decrementado en un momento

  // disminuir todos los segmentos del cuerpo de la serpiente, si el segmento es 0, apague el led correspondiente
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 16; col++) {
      //si hay un segmento del cuerpo, disminuya su valor
      if (gameboard[row][col] > 0 ) {
        gameboard[row][col]--;
      }
      //muestra el píxel actual
      if(col >  7) lc.setLed(1, row, caseM2(col), gameboard[row][col] == 0 ? 0 : 1);
      else lc.setLed(0, row, col, gameboard[row][col] == 0 ? 0 : 1);
    }
  }
}


// comprueba cuando la serpiente llega al limite y genera fin del juego
void fixEdge() {
  if(snake.col < 0)  gameOver = true;
  if(snake.col > 15) gameOver = true;
  if(snake.row < 0) gameOver = true;
  if(snake.row > 7) gameOver = true;
 // snake.row < 0 ? snake.row += 8 : 0; para no topara con paredes
 // snake.row > 7 ? snake.row -= 8 : 0;
}

void handleGameStates() {
    
  if (gameOver || win) {
     unrollSnake();
     banderaGameOver = true;
       puntuacion = (String)contadorComida;
       palabra = palabra + puntuacion;
     
    // reiniciando el juego
    win = false;
    gameOver = false;
    snake.row = random(8);
    snake.col = random(15);
    food.row = -1;
    food.col = -1;
    snakeLength = initialSnakeLength;
    snakeDirection = 0;
    memset(gameboard, 0, sizeof(gameboard[0][0]) * 8 * 16);
    lc.clearDisplay(0);
    
  }
}




void unrollSnake() {
  // apagar el LED de alimentos
  if(food.col > 7)  lc.setLed(1, food.row, caseM2(food.col), 0);
  else  lc.setLed(0, food.row, food.col, 0);

  delay(100);

  // flashear la pantalla 5 veces
  for (int i = 0; i < 2; i++) {
    // invert the screen
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 16; col++) {
       if(col > 7)lc.setLed(1, row, caseM2(col), gameboard[row][col] == 0 ? 1 : 0);
        else lc.setLed(0, row, col, gameboard[row][col] == 0 ? 1 : 0);
      }
    }

    delay(20);
    // invertirlo de nuevo
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 16; col++) {
        if(col>7) lc.setLed(1, row, caseM2(col), gameboard[row][col] == 0 ? 0 : 1);
        else lc.setLed(0, row, col, gameboard[row][col] == 0 ? 0 : 1);
      }
    }
    delay(50);
  }
  delay(100);
  for (int i = 1; i <= snakeLength; i++) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 16; col++) {
        if (gameboard[row][col] == i) {
          if(col > 7) lc.setLed(1, row, caseM2(col), 0);
           else lc.setLed(0, row, col, 0);
          delay(10);
        }
      }
    }
  }
}


 
