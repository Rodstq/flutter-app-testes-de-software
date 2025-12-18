import 'package:contasflutter/data/model/user_model.dart';
import 'package:contasflutter/viewmodel/Login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart'; // Necessário para jsonEncode e jsonDecode

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    LoginViewModel  loginViewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Laravel API'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  key: Key('input_email'),
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: Key('input_senha'),
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (loginViewModel.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        
                        await loginViewModel.login(_emailController.text, _passwordController.text);
                                              
                        Navigator.pushReplacementNamed(context, '/dashboard');
        
                      } on Exception catch (e){
                       _showSnackBarErro(context, loginViewModel.message);
                      }
                    },
                    child: const Text('Entrar'),
                  ),              
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBarErro(BuildContext context, String menssagem){
    final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.error_outline, color: Colors.white), // Ícone ajuda na leitura
        SizedBox(width: 10),
        Expanded(child: Text(menssagem)),
      ],
    ),
    backgroundColor: Colors.redAccent, // Cor de erro
    behavior: SnackBarBehavior.floating, // Fica flutuando (mais moderno)
    duration: Duration(seconds: 4), // Tempo para ler
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
    
