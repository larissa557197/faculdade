// Carregar a biblioteca de Wi-Fi
#include <WiFi.h>

// Substitua pelas credenciais da sua rede
const char* ssid = "SUA REDE WIFI";
const char* password = "SUA SENHA WIFI";

// Definir o número da porta do servidor web para 80
WiFiServer server(80);

// Variável para armazenar a solicitação HTTP
String header;

// Variáveis auxiliares para armazenar o estado atual das saídas
String output26State = "off";
String output27State = "off";

// Atribuir variáveis de saída aos pinos GPIO
const int output26 = 26;
const int output27 = 27;

// Tempo atual
unsigned long currentTime = millis();
// Tempo anterior
unsigned long previousTime = 0; 
// Definir tempo limite em milissegundos (exemplo: 2000ms = 2s)
const long timeoutTime = 2000;

void setup() {
  Serial.begin(115200);
  // Inicializar as variáveis de saída como saídas
  pinMode(output26, OUTPUT);
  pinMode(output27, OUTPUT);
  // Definir as saídas para LOW (desligadas)
  digitalWrite(output26, LOW);
  digitalWrite(output27, LOW);

  // Conectar-se à rede Wi-Fi com SSID e senha
  Serial.print("Conectando-se a ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // Imprimir o endereço IP local e iniciar o servidor web
  Serial.println("");
  Serial.println("Wi-Fi conectado.");
  Serial.println("Endereço IP: ");
  Serial.println(WiFi.localIP());
  server.begin();
}

void loop(){
  WiFiClient client = server.available();   // Escutar por clientes que tentam conectar

  if (client) {                             // Se um novo cliente se conecta
    currentTime = millis();
    previousTime = currentTime;
    Serial.println("Novo cliente.");        // Imprimir uma mensagem no monitor serial
    String currentLine = "";                // Criar uma String para armazenar dados recebidos do cliente
    while (client.connected() && currentTime - previousTime <= timeoutTime) {  // Loop enquanto o cliente estiver conectado
      currentTime = millis();
      if (client.available()) {             // Se há bytes para ler do cliente
        char c = client.read();             // Ler um byte
        Serial.write(c);                    // Imprimir no monitor serial
        header += c;
        if (c == '\n') {                    // Se o byte é um caractere de nova linha
          // Se a linha atual estiver vazia, recebeu duas novas linhas em sequência.
          // Isso indica o fim da solicitação HTTP, então envie uma resposta:
          if (currentLine.length() == 0) {
            // Cabeçalhos HTTP sempre começam com um código de resposta (ex: HTTP/1.1 200 OK)
            // e um tipo de conteúdo para o cliente saber o que esperar, depois uma linha em branco:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println("Connection: close");
            client.println();
            
            // Liga e desliga os GPIOs
            if (header.indexOf("GET /26/on") >= 0) {
              Serial.println("GPIO 26 ligado");
              output26State = "on";
              digitalWrite(output26, HIGH);
            } else if (header.indexOf("GET /26/off") >= 0) {
              Serial.println("GPIO 26 desligado");
              output26State = "off";
              digitalWrite(output26, LOW);
            } else if (header.indexOf("GET /27/on") >= 0) {
              Serial.println("GPIO 27 ligado");
              output27State = "on";
              digitalWrite(output27, HIGH);
            } else if (header.indexOf("GET /27/off") >= 0) {
              Serial.println("GPIO 27 desligado");
              output27State = "off";
              digitalWrite(output27, LOW);
            }
            
            // Exibir a página web em HTML
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            client.println("<link rel=\"icon\" href=\"data:,\">");
            // CSS para estilizar os botões de ligar/desligar
            // Fique à vontade para mudar as cores e tamanhos conforme preferir
            client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
            client.println(".button { background-color: #4CAF50; border: none; color: white; padding: 16px 40px;");
            client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
            client.println(".button2 {background-color: #555555;}</style></head>");
            
            // Cabeçalho da página
            client.println("<body><h1>Servidor Web ESP32</h1>");
            
            // Mostrar estado atual e botões ON/OFF para GPIO 26  
            client.println("<p>GPIO 26 - Estado " + output26State + "</p>");
            if (output26State=="off") {
              client.println("<p><a href=\"/26/on\"><button class=\"button\">LIGAR</button></a></p>");
            } else {
              client.println("<p><a href=\"/26/off\"><button class=\"button button2\">DESLIGAR</button></a></p>");
            } 
               
            // Mostrar estado atual e botões ON/OFF para GPIO 27  
            client.println("<p>GPIO 27 - Estado " + output27State + "</p>");
            if (output27State=="off") {
              client.println("<p><a href=\"/27/on\"><button class=\"button\">LIGAR</button></a></p>");
            } else {
              client.println("<p><a href=\"/27/off\"><button class=\"button button2\">DESLIGAR</button></a></p>");
            }
            client.println("</body></html>");
            
            // A resposta HTTP termina com outra linha em branco
            client.println();
            // Sai do loop
            break;
          } else { // Se recebeu uma nova linha, limpa a linha atual
            currentLine = "";
          }
        } else if (c != '\r') {  // Se for qualquer outro caractere que não seja "carriage return"
          currentLine += c;      // Adiciona ao final da linha atual
        }
      }
    }
    // Limpar a variável do cabeçalho
    header = "";
    // Fechar a conexão
    client.stop();
    Serial.println("Cliente desconectado.");
    Serial.println("");
  }
}
