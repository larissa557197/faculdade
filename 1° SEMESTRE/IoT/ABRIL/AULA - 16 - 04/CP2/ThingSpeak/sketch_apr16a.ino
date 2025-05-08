/***********************************************************************************
 * Projeto: Envio de Dados Aleatórios para ThingSpeak via ESP32                    *
 * Autor: André Tritiack                                                           *
 * Repositório: https://github.com/prof-atritiack/tutorial-esp32-thingspeak        *
 *                                                                                 *
 * Este projeto exemplifica como conectar o ESP32 a uma rede Wi-Fi                 *
 * e enviar múltiplos campos (fields) para um canal do ThingSpeak.                 *
 *                                                                                 *
 * Baseado em exemplos oficiais da biblioteca ThingSpeak,                          *
 * tutoriais da Random Nerd Tutorials, e documentação da Espressif.                *
 ***********************************************************************************/

// Biblioteca já instalada
#include <WiFi.h>

// Biblioteca a instalar
#include <ThingSpeak.h>

// Configurações de WiFi
const char* SECRET_SSID = "Joao";
const char* SECRET_PW = "fiaparduino";

// Configurações do ThingSpeak
WiFiClient client;
unsigned long channelID = 2912637; // Substitua 00000 pelo seu Channel ID
const char* writeAPIKey = "3QD4TQMDDXA9NIF8"; // Substitua pela sua Write API Key

// Variáveis Globais
// Substitua pelos valores que deseja enviar ao canal ThingSpeak
float Temperatura;
float Umidade;
float Pressao;
float Altitude;

// Rotina de configuração
void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);   
  ThingSpeak.begin(client);
  Serial.println("Aguardando 2 segundos para iniciar...");
  Serial.println("");
  delay(2000);  
}

// Rotina principal
void loop() {  
  // Verificação, conexão ou reconexão com a rede WiFi
  if(WiFi.status() != WL_CONNECTED){
    Serial.print("Tentando conectar a rede SSID: ");
    Serial.println(SECRET_SSID);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(SECRET_SSID, SECRET_PW);  
      Serial.print(".");
      delay(2000);     
    } 
     // Informações da conexão
    Serial.print("Rede conectada: ");
    Serial.println(WiFi.SSID());
    Serial.print("Endereço IP: ");
    Serial.println(WiFi.localIP());
    Serial.print("MAC Address: ");
    Serial.println(WiFi.macAddress());
    Serial.println("");
  }

  // Geração de dados aleatórios (simulados)
  // Substituia pelos valores que deseja enviar ao canal ThingSpeak
  Temperatura = random(110, 420) / 10.0;
  Umidade = random(0, 1000) / 10.0;
  Pressao = random(9000, 11000) / 10.0;
  Altitude = random(5000, 12000) / 10.0;

  // Envio para os campos do ThingSpeak
  ThingSpeak.setField(1, Temperatura);
  ThingSpeak.setField(2, Umidade);
  ThingSpeak.setField(3, Pressao);
  ThingSpeak.setField(4, Altitude);

  int status = ThingSpeak.writeFields(channelID, writeAPIKey);

  if (status == 200) {
    Serial.println("Dados enviados com sucesso para canal ThingSpeak!");
  } else {
    Serial.print("Erro ao enviar: ");
    Serial.println(status);
  }

  delay(20000); // Delay de 20s para respeitar o limite gratuito do ThingSpeak
}
