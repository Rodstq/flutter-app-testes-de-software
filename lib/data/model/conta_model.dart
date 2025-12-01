class Conta {
  int? id;
  String? origem;
  int? dono;
  String? donoName;
  String? data;
  String? descricao;
  double? valor;

  Conta({
    this.id,
    this.origem,
    this.dono,
    this.donoName,
    this.data,
    this.descricao,
    this.valor,
  });

  factory Conta.fromJson(Map<String, dynamic> json) {
    return Conta(
      id: json['id'] as int,
      origem: json['origem'] as String,
      dono: json['dono'] as int,
      donoName: json['name'] as String,
      data: json['data'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'origem': origem,
      'dono': dono,
      'data': data,
      'descricao': descricao,
      'valor': valor,
    };
  }
}