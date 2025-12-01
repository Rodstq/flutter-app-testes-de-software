import 'package:contasflutter/viewmodel/Login_view_model.dart';
import 'package:contasflutter/viewmodel/add_conta_view_model.dart';
import 'package:contasflutter/viewmodel/dashboard_view_model.dart';
import 'package:contasflutter/viewmodel/todas_contas_view_model.dart';
import 'package:contasflutter/views/add_conta.dart';
import 'package:contasflutter/views/dashboard.dart';
import 'package:contasflutter/views/login.dart';
import 'package:contasflutter/views/todas_contas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),

        ChangeNotifierProvider(create: (_) => DashboardViewModel()),

        ChangeNotifierProvider(create: (_) => TodasContasViewModel()), 
        ChangeNotifierProvider(create: (_) => AddContaViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[900],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.purple[900],
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/add_conta': (context) => AddConta(),
        '/todas_contas': (context) => TodasContas(),
      },
    );
  }
}
