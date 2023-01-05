
const int POT_PIN1 = A0;
const int POT_PIN2 = A1;
const int LED_PIN = 10;

void setup() {
  Serial.begin(9600);
  pinMode(POT_PIN1, INPUT);
  pinMode(POT_PIN2, INPUT);
  // pinMode(LED_PIN, OUTPUT);

}

void loop() {
  int butValue1 = analogRead(POT_PIN1);
  int butValue2 = analogRead(POT_PIN2);
  char x[25];
  sprintf(x, "%d %d", butValue1, butValue2);
  Serial.println(x);
  delay(100);
}
