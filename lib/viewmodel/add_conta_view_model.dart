import 'dart:convert';

import 'package:contasflutter/data/model/conta_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddContaViewModel extends ChangeNotifier{

  String _origem = 'Nubank';
  int _dono = 1;

  String? get origem => _origem;
  int? get dono => _dono;

  DateTime? _data; 
  DateTime? get data => _data; 

  Conta? _conta;

  setOrigem(String? origem){
    if(origem != null){
      print(origem);
      _origem = origem;
    }
    notifyListeners();
  }

  setDono(int? dono){
    if(dono != null){
        print(dono);
        _dono = dono;
      }
    notifyListeners();
  }

  Future<void> onAdicionarConta(
    {String? origem,
    int? dono,
    DateTime? data,
    String? descricao,
    double? valor,
    String? token}
  ) async {
    _conta = Conta(origem: '', dono: 0, donoName: '', data: '', descricao: '', valor: 0);

    if(origem != null){_conta!.origem = origem;};

    if(dono != null){_conta!.dono = dono;};

    if(data != null){
      DateFormat newData = DateFormat('yyyy-MM-dd');
      _conta!.data = newData.format(data);
    };

    if(descricao != null){_conta!.descricao = descricao;};

    if(valor != null){_conta!.valor = valor;};

   await enviarConta(_conta,token!);
  }

   void setData(DateTime? data) {
    _data = data;
    notifyListeners();
  }


  Future<void> enviarConta(Conta? conta, String token) async {
    String url = 'http://10.0.2.2:8000/api/add-conta';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',          
        },
        body: jsonEncode(conta?.toJson()),
      );

      if (response.statusCode == 201) {
        print('Conta enviada com sucesso!');
        final responseData = jsonDecode(response.body);
        print('Mensagem do servidor: ${responseData['message']}');
      } else {
        print('Erro ao enviar a conta. Status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      print('Erro de conexão: $e');
    }
  }

}