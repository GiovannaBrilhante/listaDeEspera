import 'package:flutter/material.dart';
import 'package:lista_espera/qrCode.dart';

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
      home: qrCode(), //inicializa nosso app com a geração do qrCode responsável pela indicação do nome do servidor e das apis existentes. 
    );
  }
}