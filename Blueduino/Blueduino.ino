#define BAUD_RATE 9600

#define BUTTON_DELAY 200

#define PLUS_ONE 20
#define MINUS_ONE 21
#define PLUS_TEN 19
#define MINUS_TEN 18
#define AUTO 5
#define STANDBY 4

//String message; 
char message;

void setup() {

  //Init output pins
  pinMode(PLUS_ONE, OUTPUT);
  digitalWrite(PLUS_ONE, LOW);

  pinMode(MINUS_ONE, OUTPUT);
  digitalWrite(MINUS_ONE, LOW);

  pinMode(PLUS_TEN, OUTPUT);
  digitalWrite(PLUS_TEN, LOW);

  pinMode(MINUS_TEN, OUTPUT);
  digitalWrite(MINUS_TEN, LOW);

  pinMode(AUTO, OUTPUT);
  digitalWrite(AUTO, LOW);

  pinMode(STANDBY, OUTPUT);
  digitalWrite(STANDBY, LOW);

  Serial.begin(BAUD_RATE);
  Serial1.begin(BAUD_RATE); 

  Serial.println("Hello BlueDuino!");
}

void loop() {

  while (Serial1.available() > 0)  {
    //message += char(Serial1.read());
    message = Serial1.read();
    delay(2);

    switch (message) {
      case '1':
        pressButton(PLUS_ONE);
        break;
      case '2':
        pressButton(MINUS_ONE);
        break;
      case '3':
        pressButton(PLUS_TEN);
        break;
      case '4':
        pressButton(MINUS_TEN);
        break;
      case '5':
        pressButton(AUTO);
        break;
      case '6':
        pressButton(STANDBY);
        break;    
    }
    
    Serial.println(message);
  }

  if (Serial.available()) {
    Serial1.write(Serial.read());
  }
}

void pressButton(int pin){
  digitalWrite(pin, HIGH);
  delay(BUTTON_DELAY);
  digitalWrite(pin, LOW);
}

