import 'package:intl/intl.dart';

//classe que trata dos dados que é inserido para cada pessoa na lista 
class Data {
  String nome;
  String data;
  String id;

  Data(this.nome, this.data, this.id);

  //retorna em json os dados da pessoa na lista
  Map toJson() => {'nome': nome, 'data': data, 'id': id};

  factory Data.fromJson(dynamic json) {
    //se não é inserida nenhuma data, passa a data atual
    if (json['data'] == null) {
      json['data'] = DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now());
    }
    //converte o json id para string 
    json['id'] = json['id'].toString();

    //retorna todas as informações como strings 
    return Data(
        json['nome'] as String, json['data'].toString(), json['id'] as String);
  }

  //sobescreve o metodo toString e retorna o nome, a data e o id
  @override
  String toString() {
    return '{${this.nome}, ${this.data}, {${this.id}}';
  }
}