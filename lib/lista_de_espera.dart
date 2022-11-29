import 'package:flutter/material.dart';
import 'data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Data>> fetchData() async{
  var response = await http.get(
    Uri.parse("http://www.slmm.com.br/CTC/getLista.php"),
    headers: {"Accept" : "application/json"});

  if(response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado...');
  }
}

class ListaEspera extends StatefulWidget {
  const ListaEspera({Key? key}) : super(key: key);

  @override
  State<ListaEspera> createState() => _ListaEsperaState();
}

class _ListaEsperaState extends State<ListaEspera> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureData = fetchData();
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
        padding: EdgeInsets.all(16),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_sharp, color: Colors.cyan,),
                          IconButton(
                            onPressed: () {
                              print(Text(data[index].data));
                            }, 
                            icon: Icon(Icons.favorite, color: Colors.red,)
                          )
                        ],
                      ),
                    ),
                  );
                });

            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}