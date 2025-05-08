// Carregar a biblioteca de Wi-Fi
#include <WiFi.h>

// Substitua pelas credenciais da sua rede
const char* ssid = "iPhone de Larissa";
const char* password = "larimuniz";


// Definir o número da porta do servidor web para 80
WiFiServer server(80);

// Variável para armazenar a solicitação HTTP
String header;

// Variáveis auxiliares para armazenar o estado atual das saídas
String output26State = "off";
String output27State = "off";
String output2State = "off";

// Atribuir variáveis de saída aos pinos GPIO
const int output26 = 26;
const int output27 = 27;
const int output2 = 2;

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
  pinMode(output2, OUTPUT);
  // Definir as saídas para LOW (desligadas)
  digitalWrite(output26, LOW);
  digitalWrite(output27, LOW);
  digitalWrite(output2, LOW);

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
            } else if (header.indexOf("GET /2/on") >= 0) {
              Serial.println("GPIO 2 ligado");
              output2State = "on";
              digitalWrite(output2, HIGH);
            } else if (header.indexOf("GET /2/off") >= 0) {
              output2State = "off";
              digitalWrite(output2, LOW);
            }
            
            // Exibir a página web em HTML
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            client.println("<link rel=\"icon\" href=\"data:,\">");

            // CSS
            client.println("<style>");
            client.println("/* Definições do corpo da página */");
            client.println("html { font-family: 'Roboto', sans-serif; background: linear-gradient(45deg, #56ccf2, #2f80ed); height: 100%; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center;}");
            client.println("body { text-align: center; color: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); max-width: 600px; width: 100%; background-color: rgba(0, 0, 0, 0.5); }");

            client.println("h1 { font-size: 2.5em; margin-bottom: 20px; color: #fff; font-weight: 700; }");
            client.println("p { font-size: 1.2em; margin: 10px 0; }");

            client.println("/* Estilos dos botões */");
            client.println(".button {");
            client.println("  background-color: #4CAF50; /* Verde claro */");
            client.println("  border: none;");
            client.println("  color: white;");
            client.println("  padding: 16px 40px;");
            client.println("  font-size: 1.2em;");
            client.println("  margin: 10px;");
            client.println("  border-radius: 8px;");
            client.println("  cursor: pointer;");
            client.println("  transition: all 0.3s ease-in-out;");
            client.println("  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);");
            client.println("  display: inline-flex;");
            client.println("  align-items: center;");
            client.println("}");

            client.println(".button2 {");
            client.println("  background-color: #FF4C4C; /* Vermelho para o botão de desligar */");
            client.println("}");

            client.println(".button:hover {");
            client.println("  background-color: #45a049;");
            client.println("  transform: translateY(-4px);");
            client.println("  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);");
            client.println("}");

            client.println(".button2:hover {");
            client.println("  background-color: #e04343;");
            client.println("  transform: translateY(-4px);");
            client.println("}");

            client.println("/* Estilos para os ícones nos botões */");
            client.println(".button i {");
            client.println("  margin-right: 8px;");
            client.println("  font-size: 1.5em;");
            client.println("}");

            client.println("/* Efeitos de transição de estado */");
            client.println("p span { font-size: 1.2em; font-weight: bold; color: #fffbf7; }");

            client.println("/* A parte do fundo e layout do texto */");
            client.println("</style>");
            client.println("</head>");

            client.println("<body>");
            client.println("<h1>Controle de Dispositivos</h1>");

            // Exibir os estados de GPIO e botões para cada um dos pinos GPIO 26, 27 e 2
            client.println("<p>GPIO 26 - Estado <span>" + output26State + "</span></p>");
            if (output26 State == "off") {
              client.println("<p><a href=\"/26/on\"><button class=\"button\"><i class=\"fa fa-power-off\"></i>LIGAR</button></a></p>");
            } else {
              client.println("<p><a href=\"/26/off\"><button class=\"button button2\"><i class=\"fa fa-power-off\"></i>DESLIGAR</button></a></p>");
            }
            
            client.println("<p>GPIO 27 - Estado <span>" + output27State + "</span></p>");
            if (output27State == "off") {
              client.println("<p><a href=\"/27/on\"><button class=\"button\"><i class=\"fa fa-power-off\"></i>LIGAR</button></a></p>");
            } else {
              client.println("<p><a href=\"/27/off\"><button class=\"button button2\"><i class=\"fa fa-power-off\"></i>DESLIGAR</button></a></p>");
            }
            
            client.println("<p>GPIO 2 - Estado <span>" + output2State + "</span></p>");
            if (output2State == "off") {
              client.println("<p><a href=\"/2/on\"><button class=\"button\"><i class=\"fa fa-power-off\"></i>LIGAR</button></a></p>");
            } else {
              client.println("<p><a href=\"/2/off\"><button class=\"button button2\"><i class=\"fa fa-power-off\"></i>DESLIGAR</button></a></p>");
            }

            client.println("</body>");
            client.println("</html>");

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
 

// coloco o ip da rede do celular conectado ao ESP32 na web e aparece uma página meio que em html com 2 botões

// colocar um terceiro botão no pino nmr2(gp2) pra ligar e desligar o led azul da placa e costumizar a página 
