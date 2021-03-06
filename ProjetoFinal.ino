
// -----------------------------------------------------------
// UNA Contagem Sistemas de Informação - 2020
//
// IoT - Projeto final da UC Sistemas distribuidos e mobile
// Consiste na medição do percentual de umidade de 03 amostras de solo por sensores.
//
// GRUPO 4
// Almir Fernandes Lopes Luiz / 41913980
// Jean Guilherme Rezende Lopes / 41910465
// Luis Paulo Alves de Faria / 41911370
// Matheus Araújo Carvalho / 41914187
// Guilherme Augusto Benfica Pereira / 41911690
//
// (C) 2020 Luis Paulo Paulo Alves, Contagem/MG - Brasil
// email luisfaria.1370@aluno.una.br
// -----------------------------------------------------------


#include <WiFiEsp.h>
#include <SoftwareSerial.h>

//PINO UTILIZADO PELO SENSOR ANALÓGICO
int sensorAnalogico = 0;


//VARIAVEIS PARA ARMAZENAR VALORES
float umidade;
int id = 0;
int numSensores = 3;

SoftwareSerial Serial1(6, 7); //PINOS QUE EMULAM A SERIAL, ONDE O PINO 6 É O RX E O PINO 7 É O TX

//char ssid[] = "2.4GNetVirtua150Apto202"; //VARIÁVEL QUE ARMAZENA O NOME DA REDE SEM FIO
//char pass[] = "Banguela87";//VARIÁVEL QUE ARMAZENA A SENHA DA REDE SEM FIO
char ssid[] = "JAVELOG"; //VARIÁVEL QUE ARMAZENA O NOME DA REDE SEM FIO
char pass[] = "javelog25651008";//VARIÁVEL QUE ARMAZENA A SENHA DA REDE SEM FIO


int status = WL_IDLE_STATUS; //STATUS TEMPORÁRIO ATRIBUÍDO QUANDO O WIFI É INICIALIZADO E PERMANECE ATIVO
//ATÉ QUE O NÚMERO DE TENTATIVAS EXPIRE (RESULTANDO EM WL_NO_SHIELD) OU QUE UMA CONEXÃO SEJA ESTABELECIDA
//(RESULTANDO EM WL_CONNECTED)

WiFiEspServer server(80); //CONEXÃO REALIZADA NA PORTA 80

RingBuffer buf(8); //BUFFER PARA AUMENTAR A VELOCIDADE E REDUZIR A ALOCAÇÃO DE MEMÓRIA

void setup(){
  Serial.begin(9600); //INICIALIZA A SERIAL
  Serial1.begin(9600); //INICIALIZA A SERIAL PARA O ESP8266
  WiFi.init(&Serial1); //INICIALIZA A COMUNICAÇÃO SERIAL COM O ESP8266
  IPAddress localIP(192,168,15,100);
  //IPAddress localIP(192,168,0,50);
  WiFi.config(localIP); //FAIXA DE IP DISPONÍVEL DO ROTEADOR

  //INÍCIO - VERIFICA SE O ESP8266 ESTÁ CONECTADO AO ARDUINO, CONECTA A REDE SEM FIO E INICIA O WEBSERVER
  if(WiFi.status() == WL_NO_SHIELD){
    while (true);
  }
  while(status != WL_CONNECTED){
    status = WiFi.begin(ssid, pass);
  }
  server.begin();
  //FIM - VERIFICA SE O ESP8266 ESTÁ CONECTADO AO ARDUINO, CONECTA A REDE SEM FIO E INICIA O WEBSERVER
}

void loop(){
  
  //ESCUTA A REQUISIÇÃO DO CLIENTE
  WiFiEspClient client = server.available();
  if (client) {
    Serial.println("novo cliente");
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (c == '\n' && currentLineIsBlank) {

        client.println("HTTP/1.1 200 OK");
        client.println("Content-Type: text/html");
        client.println("<!DOCTYPE HTML>");
        client.println();
        
        //LÊ OS VALORES DE CADA SENSOR ANALÓGICO E FAZ A CONVERSÃO EM PERCENTUAL DE UMIDADE
        for (sensorAnalogico = 0; sensorAnalogico < numSensores; sensorAnalogico++) {
        umidade = ((analogRead(sensorAnalogico)/10.25)-100)*(-1);
          
          //RESPONDE O CLIENTE COM A NUMERAÇÃO DO SENSOR E UMIDADE RESPECTIVAS EM FORMATO DE TEXTO
          client.print(sensorAnalogico);
          client.print(",");
          client.print(umidade);
          if(sensorAnalogico < (numSensores-1)){
          client.print(",");
          }
        }
          break;     
        }
        if (c == '\n') {
          currentLineIsBlank = true;
        } else if (c != '\r') {
          currentLineIsBlank = false;
        }
      }
    }
    //TEMPO PARA RECEBER OS DADOS
    delay(1);
    //FECHA A CONEXÃO
    client.stop();
    Serial.println("cliente desconectado.");
  }
}
