#include <SoftwareSerial.h>
#include <EEPROM.h>

//Create software serial object to communicate with SIM800L
SoftwareSerial MySim(7, 8); //SIM800L Tx & Rx is connected to Arduino #3 & #2
String message;
String number = ""; // add mo. number here
#define ONPIN 10
#define OFFPIN 11
#define sts 12
#define zk 9

void writeString(char add,String data);
String read_String(char add);




void setup()
{

  //Begin serial communication with Arduino and Arduino IDE (Serial Monitor)
  Serial.begin(9600);

  EEPROM.begin(512);
  String data = number; // here number will be stored 
  writeString(10, data);  //Address 10 and String type data
  delay(10);

  
  MySim.begin(9600);
  Serial.println("Initializing..."); 
  delay(2000);

  MySim.println("AT+CMGF=1"); // Configuring TEXT mode
  
  MySim.println("AT+CNMI=1,2,0,0,0"); // Decides how newly arrived SMS messages should be handled
  delay(1000);
  pinMode(ONPIN, OUTPUT);
  pinMode(OFFPIN, OUTPUT);
  pinMode(sts, OUTPUT);
  pinMode(zk, OUTPUT);
  digitalWrite(sts, LOW);
  digitalWrite(zk, LOW);
  
  delay(100);
  MySim.println("AT+CMGD=1,4");
  delay(100);
  
  }

void mskl() {
  
  delay(300);
  MySim.println("ATD"+number+";");
  delay(20000);
  MySim.println("ATH");
}

void loop()
{
 
   while (MySim.available() )
  {
    message=MySim.readString();
    Serial.println(message);
    message.toUpperCase();
    
    if (message.indexOf("9510 ON")>=0) // change your code for turn on motor
      {
        digitalWrite(sts, HIGH);
        digitalWrite(ONPIN, HIGH);
        delay(700);
        digitalWrite(ONPIN, LOW);
        mskl();
        }
    if (message.indexOf("9510 OFF")>=0) // change your code for turn off motor
      {
        digitalWrite(sts, LOW);
        digitalWrite(OFFPIN, HIGH);
        delay(700);
        digitalWrite(OFFPIN, LOW);
        mskl();
        }
    if (message.indexOf("ZK ON")>=0) // change your code for turn off motor
      {
        digitalWrite(zk, HIGH);
        }
    if (message.indexOf("ZK OFF")>=0) // change your code for turn off motor
      {
        digitalWrite(zk, LOW);
        }
        

        }
    

    delay(250);
    }



void writeString(char add,String data)
{
  int _size = data.length();
  int i;
  for(i=0;i<_size;i++)
  {
    EEPROM.write(add+i,data[i]);
  }
  EEPROM.write(add+_size,'\0');   //Add termination null character for String Data
  EEPROM.commit();
}


String read_String(char add)
{
  int i;
  char data[100]; //Max 100 Bytes
  int len=0;
  unsigned char k;
  k=EEPROM.read(add);
  while(k != '\0' && len<500)   //Read until null character
  {    
    k=EEPROM.read(add+len);
    data[len]=k;
    len++;
  }
  data[len]='\0';
  return String(data);
}
    
