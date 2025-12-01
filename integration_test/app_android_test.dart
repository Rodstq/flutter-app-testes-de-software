import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:contasflutter/main.dart' as app; 

void main() {
  // Garante que o driver do Android está pronto para receber comandos
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Testar redirecionamento para dashboard apenas com Login bem sucedido', (tester) async {
    
    // 1. INICIALIZAÇÃO
    // Inicia o app como se o usuário tivesse tocado no ícone
    app.main();
    // 'pumpAndSettle' é crucial: espera todas as animações do Android terminarem
    await tester.pumpAndSettle(); 

    // --- CENÁRIO 1: LOGIN ---
    print('--- Iniciando Teste de Login ---');
    
    // Busca os widgets pelas Keys (que você deve colocar no seu código)
    final emailField = find.byKey(const Key('input_email'));
    final senhaField = find.byKey(const Key('input_senha'));
    final btnEntrar = find.text('Entrar'); // Procura pelo texto do botão

    // Comandos de interação (Simula digitação no teclado Android)
    await tester.enterText(emailField, 'teste@myro.com');
    await tester.pumpAndSettle(); // Espera micro-animação de digitação
    
    await tester.enterText(senhaField, '123456');
    await tester.tap(btnEntrar);
    await tester.pumpAndSettle(); // Espera a transição de tela (Navegação)

    // 1. Garante que NÃO entrou na Home (Não achou "Meu Saldo")
    expect(find.text('Meu Saldo'), findsNothing);

    expect(find.textContaining('Falha geral de conexão'), findsOneWidget);


    // --- CENÁRIO 2: CADASTRO DE DESPESA (CASAL) ---
    print('--- Iniciando Teste de Despesa Casal ---');


  });

  testWidgets('Testar erro de carregamento infinito em casos de timeoutException', (tester) async {
    
    // 1. INICIALIZAÇÃO
    // Inicia o app como se o usuário tivesse tocado no ícone
    app.main();
    // 'pumpAndSettle' é crucial: espera todas as animações do Android terminarem
    await tester.pumpAndSettle(); 

    // --- CENÁRIO 1: LOGIN ---
    print('--- Iniciando Teste de Login ---');
    
    // Busca os widgets pelas Keys (que você deve colocar no seu código)
    final emailField = find.byKey(const Key('input_email'));
    final senhaField = find.byKey(const Key('input_senha'));
    final btnEntrar = find.text('Entrar'); // Procura pelo texto do botão

    // Comandos de interação (Simula digitação no teclado Android)
    await tester.enterText(emailField, 'a');
    await tester.pumpAndSettle(); // Espera micro-animação de digitação
    
    await tester.enterText(senhaField, '123456');
    await tester.tap(btnEntrar);
    await tester.pumpAndSettle(); // Espera a transição de tela (Navegação)

    // 1. Garante que NÃO entrou na Home (Não achou "Meu Saldo")
    expect(find.text('Meu Saldo'), findsNothing);

    expect(find.textContaining('Erro de resposta do servidor'), findsOneWidget);

  });
}