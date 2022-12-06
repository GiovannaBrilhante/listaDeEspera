import 'package:flutter/material.dart';
import 'tela2.dart';
import 'package:lista_espera/lista_de_espera.dart';


class qrCode extends StatefulWidget {
  const qrCode({Key? key}) : super(key: key);

  @override
  _qrCodeState createState() => _qrCodeState();
}

class _qrCodeState extends State<qrCode> {
  //Variavel que guarda o texto digitado
  final controller = TextEditingController(text: "Digite aqui");

  //Chamado quando o widget for removido da árvore widget permanentemente.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qr CODE")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          //Botão que leva para a tela2 (imagem do qrCode)
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => tela2()));
              },
              child: Text("Gerar Qr Code")),
          const SizedBox(height: 25),
          // cria TextFormField
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "QrCode text",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.ballot),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          //Botão que leva para a tela inicial (todos os cadastrados na lista, a opcão de ver detalhes, excluir e inserir)
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaEspera(controller.text)));
              },
              child: Text("Metodo alternativo para acessar a api, caso não consiga ler o qrCode")),
        ]),
      ),
    );
  }
}
