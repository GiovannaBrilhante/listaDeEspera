import 'package:intl/intl.dart';

class Data {
  String nome;
  String data;
  String id;

  Data(this.nome, this.data, this.id);

  Map toJson() => {'nome': nome, 'data': data, 'id': id};

  factory Data.fromJson(dynamic json) {
    if (json['data'] == null) {
      json['data'] = DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now());
    }
    json['id'] = json['id'].toString();

    return Data(
        json['nome'] as String, json['data'].toString(), json['id'] as String);
  }

  @override
  String toString() {
    return '{${this.nome}, ${this.data}, {${this.id}}';
  }
}