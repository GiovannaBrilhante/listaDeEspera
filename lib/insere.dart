import 'package:flutter/material.dart';
import 'data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

Future<String> inserir(String nome) async {
  String data = DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now());


  var response = await http.post(
    await Uri.parse("https://www.slmm.com.br/CTC/insere.php"),
     headers: {"Accept" : "application/json"},
     body: json.encode({"nome":nome, "data":data})
  );
  
   print(response.body);
  if(response.statusCode != 200) {
    throw Exception('Erro inesperado...'); 
  }
  return response.body;
}

class ListaInsere extends StatefulWidget {
  const ListaInsere({Key? key}) : super(key: key);

  @override
  State<ListaInsere> createState() => _ListaInsereState();
}

class _ListaInsereState extends State<ListaInsere> {
  Future<String>? _insereNome;
  final _nome = TextEditingController();

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
              const SizedBox(height: 50,),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextFormField(
                  controller: _nome,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Digite um nome: ",
                    border: InputBorder.none
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _insereNome = inserir(_nome.text);
                  });
                  Navigator.of(context).pop();
                }, 
                child: const Text("Enviar")
              )
            ],
          ),
        ),
      ),
    );
  }
}