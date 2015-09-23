const int buttonPin = 0;

int previousButtonState = LOW;

void setup() {
  // initialize serial:
  Serial.begin();

  pinMode(buttonPin, INPUT);
}

void loop() {
  int currentButtonState = digitalRead(buttonPin);
  
  if(currentButtonState == HIGH
  && previousButtonState == LOW)
  {
    Serial.write(0x01);
  }

  previousButtonState = currentButtonState;
}
