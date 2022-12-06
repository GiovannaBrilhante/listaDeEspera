import 'package:flutter/material.dart';
import 'package:lista_espera/lista_de_espera.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class tela2 extends StatefulWidget {
  const tela2({Key? key}) : super(key: key);

  @override
  _tela2State createState() => _tela2State();
}

class _tela2State extends State<tela2> {
  String link = "https://www.slmm.com.br/CTC/";
  String code = "";
  lerQRCode() async {
    code = await FlutterBarcodeScanner.scanBarcode(
      "#964b00",
      "Cancelar",
      true,
      ScanMode.QR,
    );
    setState(() => code != '-1' ? code : "Não validado");
  }

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
              child: Text("Voltar")),
          QrImage(
            data: link,
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
          ElevatedButton(onPressed: lerQRCode, child: Text("Ler qrCode")),
          ElevatedButton(
              onPressed: () {
                if (code != 'Não validado') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaEspera(code)));
                }
              },
              child: Text("Ir para tela de lista")),
        ]),
      ),  
    );
  }
}