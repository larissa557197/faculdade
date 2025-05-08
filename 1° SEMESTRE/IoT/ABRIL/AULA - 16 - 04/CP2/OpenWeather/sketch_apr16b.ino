/***********************************************************************
 * Projeto: Requisições HTTP GET com ESP32                             *
 * Autor: André Tritiack                                               *
 * Repositório: github.com/prof-atritiack/esp32-http-get-tutorial      *
 *                                                                     *
 * Este projeto exemplifica como conectar o ESP32 a uma rede Wi-Fi     *
 * e realizar requisições HTTP GET para obter dados de uma API.        *
 *                                                                     *
 * Baseado em exemplos oficiais do HTTPClient,                         *
 * tutoriais da Random Nerd Tutorials e documentação do OpenWeatherMap *
 ***********************************************************************/

// Bibliotecas já instaladas na IDE:
#include <WiFi.h>
#include <HTTPClient.h>

// Bibliotecas a instalar:
#include <Arduino_JSON.h>

// Credenciais da rede WiFi
const char* SECRET_SSID = "Joao";
const char* SECRET_PW = "fiaparduino";

// Chave da API Open Weather
String apiKey = "c2c7f59deeb40ea874635da4dc48aaa8";

// Dados do timer
unsigned long lastTime = 0;
unsigned long timerDelay = 10000;

// Variável que recebe a string JSON
String jsonBuffer;

void setup() {
  // Habilita o monitor serial:
  Serial.begin(115200);

  // Inicializa a conexão WiFi:
  WiFi.begin(SECRET_SSID, SECRET_PW);
  Serial.println("Conectando...");
  
  verificaWiFi();
 
  Serial.println("Timer programado para 10 segundos. Aguarde esse tempo para a leitura...");
}

void loop() {
  if ((millis() - lastTime) > timerDelay) { // Verifica o timer de 10 segundos.
    // Verifica o status da conexão WiFi
    if(WiFi.status()== WL_CONNECTED){
      
      String serverPath = "http://api.openweathermap.org/data/2.5/weather?q=S%C3%A3o%20Paulo,BR&APPID=" + apiKey;

      // Extraindo as informações da string JSON:
      jsonBuffer = httpGETRequest(serverPath.c_str());
      // Serial.println(jsonBuffer);
      JSONVar myObject = JSON.parse(jsonBuffer);
  
      // JSON.typeof(jsonVar) pode ser usado para obter o tipo da variável
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Falha no formato dos dados!");
        return;
      }     

      // Retorna a string JSON obtida e
      // os valores de temperatura, pressão, umidade e velocidade do vento:
      Serial.println("========================================================================");
      Serial.print("JSON object = ");
      Serial.println(myObject);
      Serial.println("========================================================================");

      // Latitude:
      Serial.print("Latitude: ");
      Serial.print(myObject["coord"]["lat"]);
      Serial.println("");

      // Longitude:
      Serial.print("Longitude: ");
      Serial.print(myObject["coord"]["lon"]);
      Serial.println("");

      // Id e Nome:
      Serial.print("Id da Cidade: ");
      Serial.println(myObject["id"]);
      Serial.print("Nome da Cidade: ");
      Serial.println(myObject["name"]);
      Serial.println("");

      Serial.println("========================================================================");
    }
    else {
      Serial.println("WiFi desconectado");
    }
    lastTime = millis(); // Reinicia o timer...
  }
}

String httpGETRequest(const char* serverName) {
  WiFiClient client;
  HTTPClient http;
    
  // Dados do servidor
  http.begin(client, serverName);
  
  // Envia a requisição GET
  int httpResponseCode = http.GET();
  
  String payload = "{}"; 
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
  }
  else {
    Serial.print("Código de erro: ");
    Serial.println(httpResponseCode);
  }
  
  http.end();

  return payload;
}

void verificaWiFi(){
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
}










