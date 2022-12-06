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
  //Variavel que guarda o endereço do servidor 
  String link = "https://www.slmm.com.br/CTC/";
  String code = "";
  // Metodo para ler o qrCode que geramos
  lerQRCode() async {
    code = await FlutterBarcodeScanner.scanBarcode(
      "#964b00", //cor da linha que fica passando, simulando uma leitura
      "Cancelar", //titulo do botão de opção de cancelar operação
      true, //adicionar flash caso o ambiente esteja escuro
      ScanMode.QR, //ler o qr
    );
     // Notifica nosso widget que seu estado interno foi alterado, verifica se dá erro, se sim retorna qrCode invalido
    setState(() => code != '-1' ? code : "qrCode inválido");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qr CODE")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ElevatedButton(
            //Botão para voltar para a tela de geração de qrCode
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Voltar")),
          //gera o qrCode com o endereço do servidor
          QrImage(
            data: link,
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
          //Botão para ler o qrCode
          ElevatedButton(onPressed: lerQRCode, child: Text("Ler qrCode")),
          //Botão quando a leitura é valida, que envia para a tela inicial (todos os cadastrados na lista, a opcão de ver detalhes, excluir e inserir)
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