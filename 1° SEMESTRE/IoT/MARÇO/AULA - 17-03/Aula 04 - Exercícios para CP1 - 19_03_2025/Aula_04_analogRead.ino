// Variável que armazenará o valor convertido pelo ADC
// ADC: Analog-to-Digital Converter de 10 bits (resolução)
// analogRead(pino) -----> 0 a 1023
// ----------------------> 0.00V a 5.00V
// 2 ^ 10 = 1024 
int valor;

void setup() {
  Serial.begin(9600); // Habilitar porta de comunicação Serial (9600 bits/s)
}

void loop() {
  valor = analogRead(A2);
  Serial.println(valor);
  delay(500);
}





