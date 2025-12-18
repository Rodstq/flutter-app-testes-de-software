import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:contasflutter/main.dart' as app; 

void main() {
  // Garante que o driver do Android está pronto para receber comandos
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  

  //CT-01
  testWidgets('Testar redirecionamento para dashboard apenas com Login bem sucedido', (tester) async {
    

    app.main();

    await tester.pumpAndSettle(); 


    print('--- Iniciando Teste de Login ---');
    

    final emailField = find.byKey(const Key('input_email'));
    final senhaField = find.byKey(const Key('input_senha'));
    final btnEntrar = find.text('Entrar');

    await tester.enterText(emailField, 'a@teste.com');
    await tester.pumpAndSettle(); 
    
    await tester.enterText(senhaField, '123456');
    await tester.tap(btnEntrar);
    await tester.pumpAndSettle(); 

    expect(find.textContaining('Meu Saldo'), findsOneWidget);

    print('--- TESTE CT-01 ACEITO COM SUCESSO ---');

  });

    //CT-02
    testWidgets('Testar credenciais inválidas', (tester) async {
    
    app.main();

    await tester.pumpAndSettle();

    print('--- Iniciando Teste de credenciais ---');
    

    final emailField = find.byKey(const Key('input_email'));
    final senhaField = find.byKey(const Key('input_senha'));
    final btnEntrar = find.text('Entrar');

    await tester.enterText(emailField, 'a@tete.com');
    await tester.pumpAndSettle(); 
    
    await tester.enterText(senhaField, '12345');
    await tester.tap(btnEntrar);
    await tester.pumpAndSettle();

    expect(find.textContaining('Credenciais inválidas'), findsOneWidget);

    print('--- TESTE CT-02 ACEITO COM SUCESSO ---');

  });

  //CT-03
  testWidgets('Testar erro de carregamento infinito em casos de timeoutException', (tester) async {
    
    app.main();

    await tester.pumpAndSettle(); 

    print('--- Iniciando Teste de TimeoutException ---');
    

    final emailField = find.byKey(const Key('input_email'));
    final senhaField = find.byKey(const Key('input_senha'));
    final btnEntrar = find.text('Entrar'); 

    await tester.enterText(emailField, 'a@teste.com');
    await tester.pumpAndSettle(); 
    
    await tester.enterText(senhaField, '123456');
    await tester.tap(btnEntrar);
    await tester.pumpAndSettle(); 

    expect(find.text('Meu Saldo'), findsNothing);

    expect(find.textContaining('Erro de resposta do servidor'), findsOneWidget);

    print('--- TESTE CT-03 ACEITO COM SUCESSO ---');

  });

  //CT-04
  testWidgets('Testar Cadastro de Despesa', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // --- LOGIN ---
    await tester.enterText(find.byKey(const Key('input_email')), 'a@teste.com');
    await tester.enterText(find.byKey(const Key('input_senha')), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // Captura saldo inicial
    final textoSaldoAntes = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
    double saldoAntes = double.parse(textoSaldoAntes);

    // --- NAVEGAÇÃO ---
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar conta'));
    await tester.pumpAndSettle();

    // Preenchimento fixo (Origem, Dono e Data)
    await tester.tap(find.text('Nubank'));
    await tester.tap(find.text('Athos'));
    await tester.tap(find.byType(TextFormField).at(0)); // Data
    await tester.pumpAndSettle();
    await tester.tap(find.text('18'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // --- ENTRADA INVÁLIDA 1: Valor vazio ---
    await tester.enterText(find.byType(TextFormField).at(1), 'Lanche');
    await tester.enterText(find.byType(TextFormField).at(2), ''); // Vazio
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    
    // Verificação: O app NÃO deve ter voltado para a Dashboard (continua na tela de adição)
    expect(find.text('Adicionar Despesa'), findsOneWidget, reason: "Deveria recusar valor vazio");

    // --- ENTRADA INVÁLIDA 2: Valor "abc" ---
    // Nota: Como você usa FilteringTextInputFormatter, o 'abc' nem será digitado
    await tester.enterText(find.byType(TextFormField).at(2), 'abc');
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Despesa'), findsOneWidget, reason: "Deveria recusar valor 'abc'");

    // --- ENTRADA VÁLIDA: Valor "20.00" ---
    await tester.enterText(find.byType(TextFormField).at(2), '20.00');
    
    // Esconder teclado e rolar
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.dragUntilVisible(find.text('Adicionar'), find.byType(SingleChildScrollView), const Offset(0, -100));
    
    await tester.tap(find.text('Adicionar'));
    
    // Se você usou o pushReplacementNamed conforme sugerido:
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // --- VALIDAÇÃO FINAL ---
    final saldoFinalTxt = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
    double saldoFinal = double.parse(saldoFinalTxt.replaceAll(RegExp(r'[^0-9.]'), ''));

    expect(saldoFinal, equals(saldoAntes - 20.00));
    
    print('--- TESTE CT-04 (PARTIÇÃO DE EQUIVALÊNCIA) FINALIZADO COM SUCESSO ---');
  });

  //CT-06
  testWidgets('Testar Valor limite', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // --- LOGIN ---
    await tester.enterText(find.byKey(const Key('input_email')), 'a@teste.com');
    await tester.enterText(find.byKey(const Key('input_senha')), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // Captura saldo inicial
    final textoSaldoAntes = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
    double saldoAntes = double.parse(textoSaldoAntes);

    // --- NAVEGAÇÃO ---
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar conta'));
    await tester.pumpAndSettle();

    // Preenchimento fixo (Origem, Dono e Data)
    await tester.tap(find.text('Nubank'));
    await tester.tap(find.text('Athos'));
    await tester.tap(find.byType(TextFormField).at(0)); // Data
    await tester.pumpAndSettle();
    await tester.tap(find.text('18'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // --- ENTRADA INVÁLIDA 1: Valor vazio ---
    await tester.enterText(find.byType(TextFormField).at(1), 'Lanche');
    await tester.enterText(find.byType(TextFormField).at(2), ''); // Vazio
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    
    // Verificação: O app NÃO deve ter voltado para a Dashboard (continua na tela de adição)
    expect(find.text('Adicionar Despesa'), findsOneWidget, reason: "Deveria recusar valor vazio");

    // --- ENTRADA INVÁLIDA 2: Valor "abc" ---
    // Nota: Como você usa FilteringTextInputFormatter, o 'abc' nem será digitado
    await tester.enterText(find.byType(TextFormField).at(2), 'abc');
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Despesa'), findsOneWidget, reason: "Deveria recusar valor 'abc'");

    // --- ENTRADA VÁLIDA: Valor "20.00" ---
    await tester.enterText(find.byType(TextFormField).at(2), '20.00');
    
    // Esconder teclado e rolar
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.dragUntilVisible(find.text('Adicionar'), find.byType(SingleChildScrollView), const Offset(0, -100));
    
    await tester.tap(find.text('Adicionar'));
    
    // Se você usou o pushReplacementNamed conforme sugerido:
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // --- VALIDAÇÃO FINAL ---
    final saldoFinalTxt = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
    double saldoFinal = double.parse(saldoFinalTxt.replaceAll(RegExp(r'[^0-9.]'), ''));

    expect(saldoFinal, equals(saldoAntes - 20.00));
    
    print('--- TESTE CT-04 (PARTIÇÃO DE EQUIVALÊNCIA) FINALIZADO COM SUCESSO ---');
  });


}