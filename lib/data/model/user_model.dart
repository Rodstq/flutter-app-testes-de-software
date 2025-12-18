// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
    int? id;
    String? name;
    String? email;
    double? saldo;
    double? salario;
    String? token;
  UserModel({
    this.id,
    this.name,
    this.email,
    this.saldo,
    this.salario,
    this.token
  });
    

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    double? saldo,
    double? salario,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      saldo: saldo ?? this.saldo,
      salario: salario ?? this.salario,
      token: token ?? this.token
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'saldo': saldo,
      'salario': salario
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      saldo: map['saldo'] != null ? double.tryParse(map['saldo']) : null,
      salario: map['salario'] != null ? double.tryParse(map['salario']) : null,
      token : map['token']
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, saldo: $saldo, salario: $salario)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.saldo == saldo &&
      other.salario == salario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      saldo.hashCode ^
      salario.hashCode;
  }
}
