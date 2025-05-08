#define ledR_carro 13
#define ledY_carro 12
#define ledG_carro 11

#define ledR_pedestre 10
#define ledG_pedestre 9


void setup() {
  Serial.begin(9600);
  pinMode(ledR_carro, OUTPUT);
  pinMode(ledY_carro, OUTPUT);
  pinMode(ledG_carro, OUTPUT);
  pinMode(ledR_pedestre, OUTPUT);
  pinMode(ledG_pedestre, OUTPUT);  

  Serial.println("------ PF1745 -------");
  delay(2000);  
}

void loop() {
  // Remova o comentário da questão a ser testada  
  questao02();  
  // questao03();  
  // questao04();  
}

void questao02(){
  // Fase 01
  Serial.println("   Fase 01   ");
  Serial.println("-------------");
  digitalWrite(ledR_carro, LOW);
  digitalWrite(ledG_carro, HIGH);
  digitalWrite(ledR_pedestre, HIGH);
  delay(5000);
   // Fase 02
  Serial.println("   Fase 02   ");
  Serial.println("-------------");
  digitalWrite(ledG_carro, LOW);
  digitalWrite(ledY_carro, HIGH);
  delay(2000);
   // Fase 03
  Serial.println("   Fase 03   ");
  Serial.println("-------------");
  digitalWrite(ledY_carro, LOW);
  digitalWrite(ledR_pedestre, LOW);
  digitalWrite(ledR_carro, HIGH);  
  digitalWrite(ledG_pedestre, HIGH);
  delay(5000);
   // Fase 04
  Serial.println("   Fase 04   ");
  Serial.println("-------------");
  digitalWrite(ledG_pedestre, LOW);
  for(int i = 0; i < 6; i++){
    digitalWrite(ledR_pedestre, HIGH);
    delay(200);
    digitalWrite(ledR_pedestre, LOW);
    delay(200);
  }  
}

void questao03(){
  
}

void questao04(){
  
}










