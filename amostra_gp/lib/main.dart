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
// (C) 2020 Jean Guilherme Rezende Lopes, Contagem/MG - Brasil
// email: creaty12345@gmail.com
// -----------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String stringResponse;
  List listResponse;
  Map mapResponse;
  List listOfFacts;

  Future fetchData() async {
    http.Response response;

    response = await http.get(
        // Código get para fazer a leitura dos dados do Thingspeak.
        'https://api.thingspeak.com/channels/1220863/feeds.json?api_key=2WDK7GV1EKJRJ2YQ&results=1');

    if (response.statusCode == 200) {
      // Se a resposta for 200 de OK, então obtemos os dados JSON.
      setState(
        () {
          mapResponse = json.decode(response.body);
          listOfFacts = mapResponse['feeds'];
        },
      );
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // Container adicionado para colocarmos uma imagem background no app.
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/1231231logo.jpg"),
                fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors
              .transparent, // Código necessário pois, como o Scaffold vem por default com a cor branca, devemos colocar transparente para que o background adicionado apareça.
          appBar: AppBar(
            title: Text(
              // Título do app.
              'Monitor de Umidade',
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
            leading: SizedBox(
                // Icone que aparece primeiro na barra ao lado esquerdo do título.
                width: 20,
                height: 20,
                child: IconButton(
                  padding: new EdgeInsets.all(10.0),
                  icon: Image.asset(
                    'assets/images/moist1.png',
                    height: 50.0,
                    width: 50.0,
                  ),
                  onPressed: () {},
                )),
            centerTitle: true,
            backgroundColor: Colors.amber[600],
            actions: <Widget>[
              IconButton(
                // Icone que aparece na barra ao lado direito do título.
                icon: Image.asset('assets/images/una02.png'),
                color: Colors.black,
                onPressed: () {},
              )
            ],
          ),
          body: mapResponse == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  // Comando de rolagem na tela.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 35, 20, 35),
                        child: Text(
                          mapResponse['channel'][
                              'description'], // Aqui determinamos de onde iremos puxar os dados no Thingspeak
                          style: TextStyle(
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ListView.builder(
                        // Aqui os dados são mostrados em forma de lista e organizados em linhas com o comando Row.
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    height: 105,
                                    width: 50,
                                    padding: EdgeInsets.all(4),
                                    color: Colors.red[900],
                                    child: Column(
                                      children: [
                                        Text(
                                          '${mapResponse['channel']['field1']} em %:', // Comando Text para nos mostrar os valores que estão no field1 em channels no Thingspeak.
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Text(
                                            listOfFacts[index]['field1'] != null
                                                ? listOfFacts[index]['field1']
                                                    .toString()
                                                : '?',
                                            style: TextStyle(
                                              fontSize: 50,
                                              color: Colors.purple[50],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    height: 105,
                                    width: 50,
                                    padding: EdgeInsets.all(4),
                                    color: Colors.blue[900],
                                    child: Column(
                                      children: [
                                        Text(
                                          '${mapResponse['channel']['field2']} em %:', // Comando Text para nos mostrar os valores que estão no field2 em channels no Thingspeak.
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Text(
                                            listOfFacts[index]['field2'] != null
                                                ? listOfFacts[index]['field2']
                                                    .toString()
                                                : '?',
                                            style: TextStyle(
                                              fontSize: 50,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    height: 105,
                                    width: 50,
                                    padding: EdgeInsets.all(4),
                                    color: Colors.green[900],
                                    child: Column(
                                      children: [
                                        Text(
                                          '${mapResponse['channel']['field3']} em %:', // Comando Text para nos mostrar os valores que estão no field3 em channels no Thingspeak.
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Text(
                                            listOfFacts[index]['field3'] != null
                                                ? listOfFacts[index]['field3']
                                                    .toString()
                                                : '?',
                                            style: TextStyle(
                                              fontSize: 50,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: listOfFacts == null ? 0 : listOfFacts.length,
                      )
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            // Botão apara atualizar os dados na tela.
            onPressed: () {
              print('Update.');
              setState(
                () {
                  mapResponse = null;
                },
              );
              fetchData();
            },
            child: Icon(
              Icons.sync_sharp,
              color: Colors.black,
            ),
            backgroundColor: Colors.amber[600],
          ),
        ));
  }
}
