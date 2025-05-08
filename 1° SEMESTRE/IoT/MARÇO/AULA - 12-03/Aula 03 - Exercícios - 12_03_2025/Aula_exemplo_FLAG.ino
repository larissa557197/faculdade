// Atribuir nomes aos pinos
// Botões 1 e 2
#define BT1 8
#define BT2 9
#define BT3 10
// LEDs 
#define ledB 2
#define ledW 3
#define ledR 4

bool statusBT1, flag1; 

void setup() {
  Serial.begin(9600);
  // Configurar o sentido dos pinos de I/O
  pinMode(BT1, INPUT);
  pinMode(BT2, INPUT);
  pinMode(BT3, INPUT);

  pinMode(ledB, OUTPUT);
  pinMode(ledW, OUTPUT);
  pinMode(ledR, OUTPUT);

}

// Rotina principal
void loop() {
  statusBT1 = digitalRead(BT1);
  delay(100); // minimizar o efeito debounce

  if(statusBT1 == 1 && flag1 == 0){
    flag1 = 1;
    delay(300);
    Serial.println("O botao foi pressionado");
    // Foi detectada a borda de subida 
  }

  if(statusBT1 == 0 && flag1 == 1){
    Serial.println("O botão foi desligado");
    flag1 = 0;
    // Foi detectada a borda de descida
    // TO DO!!!!!!
  }
  
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








