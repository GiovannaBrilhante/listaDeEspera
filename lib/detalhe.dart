oi evertonn 
oieeeeee
kkkkkkk
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:lista_espera/lista_de_espera.dart';
import 'package:lista_espera/data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Detalhes extends StatefulWidget {
  // variavel para guardar o endereço do servidor
  final String qrCodeServer;
  // variavel para guardar o id que quero ver os detalhes
  final String id;
  //construtor da classe
  const Detalhes(this.id,this.qrCodeServer, {super.key});

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  //getExibeDetalhes, função que informa o endereço da api que deve buscar na lista, a pessoa determinada pelo id e pegar seus detalhes
  Future<Data> getExibeDetalhes(String id) async {
    //pegando o endereço desejado da API para detalhes
    var response = await http.get(Uri.parse(widget.qrCodeServer + "getDetalhe.php?id=$id"),
        headers: {"Accept": "application/json"});

    //verifica se a api está funcionando, e pega as informações para detalhamento, se não estiver, dá erro
    if (response.statusCode == 200) {
      final Map indiv = json.decode(response.body)[0];
      return Data(indiv["nome"], indiv["data"], indiv["id"].toString());
    } else {
      throw Exception('Não foi possível detalhar.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: FutureBuilder<Data>(
                    // passando para o atributo future os detalhes do id desejado - obtendo dados
                    future: getExibeDetalhes(widget.id),
                    builder: (context, snapshot) {
                      // verificando se os dados foram obtidos
                      if (snapshot.hasData) {
                        // passa para a variável data, da classe data, os dados que ele recebeu
                        Data data = snapshot.data!;
                        
                        /*DateTime dataAtual = DateTime.now();
                        DateTime dataFila = DateTime.parse(data.data);
                        Duration tempoFila = dataAtual.difference(dataFila);*/

                        // Para calcular o tempo na fila, pega a data atual e subtrai a data que entrou na lista
                        DateTime entradaNaLista = DateTime.parse(
                            data.data); // data de entrada na fila
                        DateTime agora = DateTime.now(); // data atual
                        Duration durTempoNaLista = agora.difference(
                            entradaNaLista); // diferença entre as datas

                        String tempoNaLista = DateFormat('HH:mm:ss')
                            .format(// Converte pra string hh mm ss
                                // formata a diferença para HH:mm:ss
                                DateTime.fromMillisecondsSinceEpoch(
                                    // Transforma milisegundos em data
                                    durTempoNaLista.inMilliseconds,
                                    isUtc: true));

                        return Center(
                            child: Column(
                          children: [
                            ListTile(
                                visualDensity:
                                    VisualDensity(vertical: -3), // to compact
                                tileColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                  //<-- SEE HERE
                                  side: const BorderSide(width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                //Exibe o nome do id passado no getExibeDetalhes como sendo o titulo
                                leading: const Icon(Icons.person),
                                title: Text(
                                  data.nome,
                                  style: const TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //Exibe o id passado no getExibeDetalhes e o tempo na lista que calculamos como sendo o subtitulo
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Id: ' + data.id,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Tempo na lista: ' + tempoNaLista + ' ',
                                      style: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ));
                      } /*se os dados não foram obtidos, dá erro*/ else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    }))));
  }
}
