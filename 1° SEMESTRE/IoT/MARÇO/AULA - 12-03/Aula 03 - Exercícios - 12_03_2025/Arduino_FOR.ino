// Atribuir nomes aos pinos
// Botões 1 e 2
#define BT1 8
#define BT2 9
#define BT3 10
// LEDs 
#define ledB 2
#define ledW 3
#define ledR 4

// bool statusBT1; 

int contador; 
// variável do tipo inteiro ---> 2^16 = 65.536 (64k)

void setup() {
  Serial.begin(9600);
  // Configurar o sentido dos pinos de I/O
  pinMode(BT1, INPUT);
  pinMode(BT2, INPUT);
  pinMode(BT3, INPUT);

  pinMode(ledB, OUTPUT);
  pinMode(ledW, OUTPUT);
  pinMode(ledR, OUTPUT);

  for(int i = 0; i < 10; i++) {
    Serial.println();
    piscaW();
  }
  Serial.println("Fim da inicializacao");
  delay(2000);
}

// Rotina principal
void loop() {
  piscaRB();
}

void piscaRB(){
  digitalWrite(ledB, HIGH);
  digitalWrite(ledR, LOW);
  delay(250);
  digitalWrite(ledR, HIGH);
  digitalWrite(ledB, LOW);
  delay(250);  
}

void piscaW(){
  digitalWrite(ledR, LOW);
  digitalWrite(ledW, HIGH);
  delay(350);
  digitalWrite(ledW, LOW);
  delay(350);
}








