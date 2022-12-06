import 'package:flutter/material.dart';
import 'package:lista_espera/insere.dart';
import 'package:lista_espera/detalhe.dart';
import 'package:lista_espera/data.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ListaEspera extends StatefulWidget {
  // variavel para guardar o endereço do servidor
  final String qrCodeServer;
  //construtor da classe
  const ListaEspera(this.qrCodeServer, {super.key});

  @override
  State<ListaEspera> createState() => _ListaEsperaState();
}

class _ListaEsperaState extends State<ListaEspera> {
  // declara uma lista de Data chamada de futureData que será inicializada posteriormente
  late Future<List<Data>> futureData;

  //Chamado na criação do widget, para inseri-lo na arvore widget
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  // classe que tem a função de exbir todas as pessoas cadastradas na api na nuvem
  Future<List<Data>> fetchData() async {
    //pegando o endereço desejado da API para exbir todos os cadastros com o metodo get
    var response = await http.get( Uri.parse("${widget.qrCodeServer}getLista.php"),
        headers: {"Accept": "application/json"});

    //verifica se a api está funcionando, e traz as informações, se não estiver, dá erro
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Não é possível exibir a lista');
    }
  }

  // classe que tem a função de deletar uma pessoa cadastrada na api na nuvem através do id
  Future<String> deletarPessoaDaLista(String id) async {
    //pegando o endereço desejado da API para deletar o desejado com o metodo delete
    var response = await http.delete(
        Uri.parse("${widget.qrCodeServer}delete.php?id=$id"),
        headers: {"Accept": "application/json"});

    //verifica se a api está funcionando, e traz as informações de quem está sendo deletado, se não estiver, dá erro
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
          title: const Text("Lista de espera"),
          centerTitle: true,
          backgroundColor: Colors.purple,
          actions: [IconButton(onPressed: (){
            setState(() {
              futureData = fetchData();
            });
          }, icon: Icon(Icons.refresh))],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            SizedBox(
              height: 550,
              child: FutureBuilder<List<Data>>(
                // passando para o atributo future a lista de dados - obtendo dados
                future: futureData,
                builder: (context, snapshot) {
                  // verificando se os dados foram obtidos
                  if (snapshot.hasData) {
                     // passa para a variável data, da classe data em lista, os dados que ele recebeu
                    List<Data> data = snapshot.data!;
                    //retorna o nome e a posição de cada um, com a op´ção de exiber detalhes ou excluir aquele id e suas informações
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
                                  //Botão para exibir detalhes que leva para a página de detalhes
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
                                  //Botão para deletar a pessoa
                                  IconButton(
                                      onPressed: () {
                                        //passa para a classe deletarPessoaDaLista o id de quem teve o botão pressionafo
                                        deletarPessoaDaLista(data[index].id);
                                        //remove a pessoa
                                        snapshot.data!.removeAt(index);
                                        // Notifica nosso widget que seu estado interno foi alterado, atualiza a alteração na tela
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
                  } /*se os dados não foram obtidos, dá erro*/ else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //Botão para inserir mais pessoas que leva para a pagina de inserir
            IconButton(
              style: IconButton.styleFrom(
                fixedSize: Size(212, 212)
              ),
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
