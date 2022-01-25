#include <Servo.h>

Servo myservo1;
Servo myservo2;
int pos = 0;
int ledRed = 10;
int ledGreen = 11;
int btnReset = 7;
int tiempoInicio = 0;
int tiempoFin = 0;
bool banderaDistancia = false;
//sensor HC-SR04
//la función del sensor ultrasónico es darnos el tiempo en el que una onda se tarda en ir y regresar.
long duracion;  //tiempo en el que la onda viaja y regresa
long distancia; // float distancia para obtener 
int pos1 =0;
int pos2 =0;
int trig=13; //recibe un pulso mandado por arduino para comenzar con el ciclo de medicion
int echo=12; //devuelve arduino un pulso continuo, comienza desde que se envian las ondas ultrasónicas,
//hasta que se reciben




void setup() {
  myservo1.attach(14);  //declaramos que el servo está conectado al pin 14 del arduino
  myservo2.attach(15);  //declaramos que el servo está conectado al pin 15 del arduino

  Serial.begin(9600);
  pinMode(trig,OUTPUT); // declaramos pin de salida, para el emisor - Salida
  pinMode(echo,INPUT); // declaramos pin de entrada, para Receptor - Entrada
  pinMode(ledRed,OUTPUT); //declaramos el pin de led, como salida
  pinMode(ledGreen,OUTPUT); //declaramos el pin de led, como salida
  pinMode(btnReset,INPUT);

}

void loop() {
  //************* disparo para activar el sensor ***************
  tiempoInicio = millis();
  
  Serial.println(distancia);
  //Para estabilizar nuestro módulo ultrasónico
  digitalWrite(trig,LOW);
  delayMicroseconds(4);
  //disparo de un pulso en el trigger de longitud 10us
  digitalWrite(trig,HIGH);
  delayMicroseconds(10);
  digitalWrite(trig,LOW);
  //************** termina el disparo de activación *************
  
  //PulseIn : Lectura de la duración del pulso HIGH generado hasta recibir el Echo y vuelva a estar en bajo LOW
  duracion=pulseIn(echo,HIGH); //duración en ir y regresar la onda ultrasónica

  //Calculo distancia
  distancia=duracion/58.4;// (cm)
  
  if (distancia <=100){
    banderaDistancia = true;
    digitalWrite(ledRed,HIGH);
    digitalWrite(ledGreen,LOW);
    delay(10);
  }else {
    banderaDistancia = false;
    digitalWrite(ledGreen,HIGH);
    digitalWrite(ledRed,LOW);
  }
  
  if(banderaDistancia==true){
    
    
    }else{
      if(pos1<=180 && tiempoInicio-tiempoFin >=1000){
    tiempoFin = tiempoInicio;
    pos1+=10;
    myservo1.write(pos1); 
    
    }
  if(pos1>180){
    if(pos2<=180 && tiempoInicio-tiempoFin >=1000){
    tiempoFin = tiempoInicio;
    pos2+=10;
    myservo2.write(pos2); 
    
    }
    }
      }

    
  
  

}
