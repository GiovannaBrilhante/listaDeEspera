import 'package:flutter/material.dart';
import 'package:lista_espera/data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class ListaInsere extends StatefulWidget {
  // variavel para guardar o endereço do servidor
  final String qrCodeServer;
  //construtor da classe
  const ListaInsere(this.qrCodeServer, {super.key});

  @override
  State<ListaInsere> createState() => _ListaInsereState();
}

class _ListaInsereState extends State<ListaInsere> {
  Future<String>? _insereNome;
  final _nome = TextEditingController();
  // classe que tem a função de inserir o nome que está sendo cadastrado na api na nuvem
  Future<String> inserir(String nome) async {
    //pegando o endereço desejado da API para inserir o nome e a data com o metodo post
    final response = await http.post(
      Uri.parse(widget.qrCodeServer + 'insere.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'nome': nome,
        'data': DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now()),
      }),
    );

    print(response.body);
    //verifica se a api está funcionando, e insere as informações, se não estiver, dá erro
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Não foi possível inserir.');
    }
  }

  //Chamado quando o widget for removido da árvore widget permanentemente.
  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserir"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // Para digitar o nome que deseja inserir
              Container(
                width: 300,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: _nome,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: "Digite um nome: ", border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Para inserir o nome
              ElevatedButton(
                  onPressed: () {
                    // Notifica nosso widget que seu estado interno foi alterado, atualiza a alteração na tela
                    setState(() {
                      _insereNome = inserir(_nome.text);
                    });
                    // Depois de inserido ele volta para a tela inicial
                    Navigator.of(context).pop();
                  },
                  child: const Text("Enviar"))
            ],
          ),
        ),
      ),
    );
  }
}
