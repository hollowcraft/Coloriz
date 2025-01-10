const int pinLed = 2;
const int pinBouton1 = 4;
const int pinBouton2 = 7;

void setup() {
  pinMode(pinLed, OUTPUT);
  pinMode(pinBouton1, INPUT);
  pinMode(pinBouton2, INPUT);
}

void loop() {
  int b1 =digitalRead(pinBouton1);
  int b2 =digitalRead(pinBouton2);
  if (b1==HIGH || b2==HIGH) {
    digitalWrite(pinLed, HIGH);
    delay(5000);
    digitalWrite(pinLed, LOW);
  }
}
