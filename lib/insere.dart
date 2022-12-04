import 'package:flutter/material.dart';
import 'data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

Future<Data> fetchData(String nome) async{
  var response = await http.post(
    Uri.parse("https://www.slmm.com.br/CTC/insere.php"),
    headers: {"Accept" : "application/json"},
    body: {"nome": nome, "data": DateFormat("yy/mm/dd - hh/mm/ss").format(DateTime.now())});

  if(response.statusCode == 200) {
    return Data.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro inesperado...');
  }
}

class ListaInsere extends StatefulWidget {
  const ListaInsere({Key? key}) : super(key: key);

  @override
  State<ListaInsere> createState() => _ListaInsereState();
}

class _ListaInsereState extends State<ListaInsere> {
  late Future<Data>? _futureData;
  final _nome = TextEditingController();

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
                    _futureData = fetchData(_nome.text);
                  });
                  Navigator.of(context).pop();
                }, 
                child: Text("Enviar")
              )
            ],
          ),
        ),
      ),
    );
  }
}