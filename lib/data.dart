class Data{
  String nome;
  String data;

  Data(this.nome, this.data);

  Map toJson() => {'nome' : nome, 'data': data};

  factory Data.fromJson(dynamic json) {
    return Data(json['nome'] as String, json['data'].toString());
  }

  @override
  String toString() {
    return '{${this.nome}, ${this.data}}';
  }
}