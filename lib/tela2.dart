import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class tela2 extends StatefulWidget {
  const tela2({Key? key}) : super(key: key);

  @override
  _tela2State createState() => _tela2State();
}

class _tela2State extends State<tela2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qr CODE")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("voltar")),
          QrImage(
            data: "https://www.slmm.com.br/CTC/",
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),


        ]),
      ),
    );
  }
}
