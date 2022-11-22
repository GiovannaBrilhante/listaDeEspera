import 'package:flutter/material.dart';
import 'package:lista_espera/lista_de_espera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lista de Espera',
      debugShowCheckedModeBanner: false,
      home: ListaEspera(),
    );
  }
}