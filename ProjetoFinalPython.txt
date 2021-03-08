# -----------------------------------------------------------
# UNA Contagem Sistemas de Informação - 2020
#
# IoT - Projeto final da UC Sistemas distribuidos e mobile
# Consiste na medição do percentual de umidade de 03 amostras de solo por sensores.
#
# GRUPO 4
# Almir Fernandes Lopes Luiz / 41913980
# Jean Guilherme Rezende Lopes / 41910465
# Luis Paulo Alves de Faria / 41911370
# Matheus Araújo Carvalho / 41914187
# Guilherme Augusto Benfica Pereira / 41911690
#
# (C) 2020 Luis Paulo Paulo Alves, Contagem/MG - Brasil
# email luisfaria.1370@aluno.una.br
# -----------------------------------------------------------

import requests
import sqlite3
import urllib3
from datetime import datetime


# ENVIA REQUISIÇÃO HTTP AO DISPOSITIVO E IMPRIME O RETORNO
url = 'http://192.168.15.100'
#url = 'http://192.168.0.50'
r = requests.get(url)

# ARMAZENA VALORES DE DATA E HORA DA LEITURA
d = datetime.now()
dataHora = d.strftime('%d/%m/%Y %H:%M')


# EXTRAI OS DADOS DO TEXTO RECEBIDO E FORMATA COMO LISTA
# PARA EXTRAIR DADOS DE MAIS SENSORES, SEGUIR A SEQUÊNCIA NUMÉRICA DAS VARIAVEIS "sensNum" E "umidNum" (+7)
sensNum = [0, 7, 14]
umidNum = [2, 9, 16]
sens = (int(r.text[sensNum[0]]), int(r.text[sensNum[1]]), int(r.text[sensNum[2]]))
umid = (int(r.text[umidNum[0]]), int(r.text[umidNum[1]]), int(r.text[umidNum[2]]))
data = (dataHora[0:19], dataHora[0:19], dataHora[0:19])
dadosLista = list(zip(sens, umid, data))

# ABRE O BANCO DE DADOS E INSERE A LISTA CRIADA
conn = sqlite3.connect("C:/sqlite3/projetoFinal.db")
cursor = conn.cursor()
cursor.executemany("INSERT INTO umidadeSolo (id, sensor, umidade, data) VALUES (NULL, ?, ?, ?)", dadosLista)

conn.commit()

# SELECIONA OS 03 ÚLTIMOS VALORES DE UMIDADE DA TABELA E CRIA UMA LISTA
sql_query = "SELECT umidade FROM umidadeSolo WHERE id >=(SELECT max(id) FROM umidadeSolo) - 2 ORDER BY Sensor ASC LIMIT 3"
cursor.execute(sql_query)
dadosSql = cursor.fetchmany(3)

print("Dados inseridos na tabela com sucesso.")
conn.close()

# FORMATA OS DADOS DA LISTA EXTRAIDA DO BANCO DE DADOS
dados = str(dadosSql)
dados = dados.replace(',', '')

# PARA ACRESCENTAR MAIS SENSORES, SEGUIR A SEQUÊNCIA NUMÉRICA DAS VARIAVEIS (+4)
umidadeSensor0 = dados[2]
umidadeSensor1 = dados[6]
umidadeSensor2 = dados[10]

# LISTAS PARA GERAR A URL
sensores = [umidadeSensor0, umidadeSensor1, umidadeSensor2]
field = ['1', '2', '3']
urlThing = "https://api.thingspeak.com/update?api_key=4YE5MOPSO768DU10&field"

# ENVIO DAS INFORMAÇÕES PARA O THINGSPEAK
http = urllib3.PoolManager()
req = http.request("GET", urlThing + field[0] + "=" + sensores[0] +
                   "&field" + field[1] + "=" + sensores[1] +
                   "&field" + field[2] + "=" + sensores[2])
print("Thingspeak atualizado com sucesso.")
