import 'package:flutter/material.dart';
import 'package:lista_espera/insere.dart';
import 'package:lista_espera/detalhe.dart';
import 'package:lista_espera/data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ListaEspera extends StatefulWidget {
  final String qrCodeServer;
  const ListaEspera(this.qrCodeServer, {super.key});

  @override
  State<ListaEspera> createState() => _ListaEsperaState();
}

class _ListaEsperaState extends State<ListaEspera> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Data>> fetchData() async {
    var response = await http.get(
        Uri.parse(widget.qrCodeServer + "getLista.php"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Erro inesperado...');
    }
  }

  Future<String> deletarPessoaDaLista(String id) async {
    var response = await http.delete(
        Uri.parse(widget.qrCodeServer + "delete.php?id=" + id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Erro inesperado...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Espera"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            SizedBox(
              height: 610,
              child: FutureBuilder<List<Data>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Data> data = snapshot.data!;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(data[index].nome),
                              subtitle:
                                  Text("👥 Posição: " + (index + 1).toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) => Detalhes(
                                                    data[index].id,
                                                    widget.qrCodeServer))));
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Color.fromARGB(255, 134, 0, 212),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        deletarPessoaDaLista(data[index].id);
                                        snapshot.data!.removeAt(index);
                                        setState(() {
                                          futureData = fetchData();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.cyan,
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          ListaInsere(widget.qrCodeServer))));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.red,
                  size: 30,
                ))
          ]),
        ));
  }
}
