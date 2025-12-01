import 'dart:convert';

import 'package:contasflutter/data/model/conta_model.dart';
import 'package:contasflutter/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardViewModel extends ChangeNotifier {

  double total = 0.0;
  List<Conta>? _contasFuture;
  List<Conta>? get contasFuture => _contasFuture;
  Set<String> _origens = {};

  Set<String> get origens => _origens;

  bool _isLoading = true;
  bool get isLoading => _isLoading ;


  void setOrigens(List<Conta> contas){
    for(Conta conta in contas){
      if(conta.origem != null){
        _origens.add(conta.origem!);
      }
      print(_origens);
    }
  }
  void setTotal(double valor){
    total += valor;
    notifyListeners();
  }

  Future<List<Conta>> fetchContas() async {

      _isLoading = true;
      notifyListeners();

      final List<Conta> allContas = [];
      total=0;

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/all-contas'),
        headers: {
          'Authorization':
              'Bearer 1|oLZbB94rVXdXSYQT9f2cgAxpGhhvQhiLOvO2xdcSeb8e06ca',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = utf8.decode(response.bodyBytes);

        List<dynamic>? jsonMap;

        try {
          final List<dynamic> decodedList = jsonDecode(raw);

          final List<Map<String, dynamic>> jsonMap =
              List<Map<String, dynamic>>.from(decodedList);

          if (jsonMap != null) {
            for (Map<String, dynamic> item in jsonMap) {

              final Conta conta = Conta.fromJson(item);

              print('CONTA DA VEZ ${conta.descricao}');
              print('CONTA DA VEZ ${conta.data}');
              print('CONTA DA VEZ ${conta.donoName}');
              print('CONTA DA VEZ ${conta.valor}');


              if (conta.valor != null){
                total += conta.valor! ;
              }

              allContas.add(conta);              
            }
            setOrigens(allContas);
          }
        } catch (e) {
          print('$e');
        }
      }

      _isLoading = false;
      notifyListeners();

      return allContas;
  }
  

  Future<List<Conta>> fetchMyContas(int id) async {
      final List<Conta> allContas = [];
      total=0;

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/all-my-contas'),
        headers: {
          'Authorization':
              'Bearer 1|oLZbB94rVXdXSYQT9f2cgAxpGhhvQhiLOvO2xdcSeb8e06ca',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = utf8.decode(response.bodyBytes);

        List<dynamic>? jsonMap;

        try {
          final List<dynamic> decodedList = jsonDecode(raw);

          final List<Map<String, dynamic>> jsonMap =
              List<Map<String, dynamic>>.from(decodedList);

          if (jsonMap != null) {
            for (Map<String, dynamic> item in jsonMap) {

              final Conta conta = Conta.fromJson(item);

              print('CONTA DA VEZ ${conta.descricao}');
              print('CONTA DA VEZ ${conta.data}');
              print('CONTA DA VEZ ${conta.donoName}');
              print('CONTA DA VEZ ${conta.valor}');

              if (conta.valor != null){
                total += conta.valor! ;
              }

              allContas.add(conta);              
            }
            setOrigens(allContas);
          }
        } catch (e) {
          print('$e');
        }
      }
      return allContas;
  }
  


  Future<void> init() async{
    _contasFuture = await fetchContas ();
    notifyListeners();
  }
}
