import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:lista_espera/lista_de_espera.dart';
import 'package:lista_espera/data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Detalhes extends StatefulWidget {
  final String qrCodeServer;
  final String id;
  const Detalhes(this.id,this.qrCodeServer, {super.key});

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
// pegar usuario pelo id
  Future<Data> getExibeDetalhes(String id) async {
    var response = await http.get(Uri.parse(widget.qrCodeServer + "getDetalhe.php?id=$id"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final Map indiv = json.decode(response.body)[0];
      return Data(indiv["nome"], indiv["data"], indiv["id"].toString());
    } else {
      throw Exception('Erro inesperado...');
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
                    future: getExibeDetalhes(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Data data = snapshot.data!;
                        // tempo na fila
                        // tempo na fila
                        DateTime dataAtual = DateTime.now();
                        DateTime dataFila = DateTime.parse(data.data);
                        Duration tempoFila = dataAtual.difference(dataFila);

                        DateTime entradaNaFila = DateTime.parse(
                            data.data); // data de entrada na fila
                        DateTime agora = DateTime.now(); // data atual
                        Duration durTempoNaFila = agora.difference(
                            entradaNaFila); // diferença entre as datas

                        String tempoNaLista = DateFormat('HH:mm:ss')
                            .format(// Converte pra string hh mm ss
                                // formata a diferença para HH:mm:ss
                                DateTime.fromMillisecondsSinceEpoch(
                                    // Transforma milisegundos em data
                                    durTempoNaFila.inMilliseconds,
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
                                leading: const Icon(Icons.person),
                                title: Text(
                                  'Nome: ' + data.nome,
                                  style: const TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                      'Tempo na fila: ' + tempoNaLista + ' ',
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
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // by default
                      return const CircularProgressIndicator();
                    }))));
  }
}
