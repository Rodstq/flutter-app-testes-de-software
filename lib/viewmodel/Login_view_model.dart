import 'dart:async';
import 'dart:convert';

import 'package:contasflutter/data/model/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoginViewModel  extends ChangeNotifier{

  UserModel? user;

  double saldoTemporario = 0;

  String message = '';
  bool isLoading = false;

  // Função para realizar o login
  Future<void> login( String email, String password) async {
    
    isLoading = true;
    notifyListeners();
    message = '';

    final url = Uri.parse('http://10.0.2.2:8000/api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
          const Duration(seconds: 10),
        );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Sucesso!
        final token = responseData['access_token'];

        final Map<String, dynamic> userMap = responseData['user'];

        final UserModel loggedInUser = UserModel.fromMap(userMap);

        user = loggedInUser;

        print('Token de acesso: $token');
        print('Usuário logado: ${loggedInUser.name.toString()}');

      } else if (response.statusCode == 422) {

        isLoading = false;
        notifyListeners();

        message = responseData['message'] ?? 'Credenciais inválidas.';
        throw Exception('Credenciais inválidas.');
      } else {
        
      isLoading = false;
      notifyListeners();

       message = 'Erro ao fazer login: ${response.statusCode}';
       throw Exception('Erro ao fazer login');
      }

      
      isLoading = false;
      notifyListeners();
    } on TimeoutException catch(e){
      isLoading = false;
      notifyListeners();
      message = 'Erro de resposta do servidor:';
      rethrow;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      message = 'Falha geral de conexão:';
      rethrow;
    }
  }

  void setSaldo(double totalContas) {
    if (user != null) {
      // Altera o estado interno do objeto 'user'
      if (user!.saldo != null){        
          saldoTemporario = user!.saldo! - totalContas;
          notifyListeners();
      }
    }
  }
}