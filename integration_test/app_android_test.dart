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

  expect(find.textContaining('Saldo Total'), findsOneWidget);

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

expect(find.textContaining('As credenciais fornecidas estão incorretas'), findsOneWidget);

print('--- TESTE CT-02 ACEITO COM SUCESSO ---');

});

  //CT-03
// TESTAR COM SERVIDOR DESLIGADO
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
await Future.delayed(const Duration(seconds: 2));
await tester.dragUntilVisible(find.text('Adicionar'), find.byType(SingleChildScrollView), const Offset(0, -200));

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

//CT-05
testWidgets('Testar Exclusão de Despesa', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // --- LOGIN ---
  await tester.enterText(find.byKey(const Key('input_email')), 'a@teste.com');
  await tester.enterText(find.byKey(const Key('input_senha')), '123456');
  await tester.tap(find.text('Entrar'));
  await tester.pumpAndSettle();

  // 1. Captura saldo ANTES de adicionar a conta
  final textoSaldoInicial = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
  double saldoInicial = double.parse(textoSaldoInicial.replaceAll(RegExp(r'[^0-9.]'), ''));

  // --- ADICIONAR CONTA PARA TESTE ---
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Adicionar conta'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Nubank'));
  await tester.tap(find.text('Athos'));
  await tester.tap(find.byType(TextFormField).at(0)); // Data
  await tester.pumpAndSettle();
  await tester.tap(find.text('18'));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  const String descricaoTeste = 'Lanche para excluir';
  const double valorTeste = 35.00;

  await tester.enterText(find.byType(TextFormField).at(1), descricaoTeste);
  await tester.enterText(find.byType(TextFormField).at(2), valorTeste.toString());
  
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  await tester.dragUntilVisible(find.text('Adicionar'), find.byType(SingleChildScrollView), const Offset(0, -200));

  await tester.tap(find.text('Adicionar'));
  await tester.pumpAndSettle(const Duration(seconds: 20)); // Aguarda processamento e retorno


  final finderSaldo = find.byKey(const Key('valor_saldo_total'));
  await tester.ensureVisible(finderSaldo);

  // 2. Verifica saldo após adicionar (deve ter diminuído 35)
  final textoSaldoPosAdicao = tester.widget<Text>(finderSaldo).data!;
  double saldoPosAdicao = double.parse(textoSaldoPosAdicao.replaceAll(RegExp(r'[^0-9.]'), ''));

  print('--- Localizando conta para exclusão ---');
  
  // 1. Finder do texto específico
  final finderTexto = find.text(descricaoTeste);

  // 2. FORÇAR SCROLL: Rola a lista até que o texto da conta esteja visível
  // Usamos find.byType(ListView).first para identificar onde o scroll deve ocorrer
  await tester.dragUntilVisible(
    finderTexto,
    find.byType(ListView).first,
    const Offset(0, -100), // Rola para baixo
  );
  await tester.pumpAndSettle();

  // 3. Identificar o Card pai e o botão de lixeira
  final finderCard = find.ancestor(
    of: finderTexto,
    matching: find.byType(Card),
  );

  final btnLixeira = find.descendant(
    of: finderCard,
    matching: find.byIcon(Icons.delete_forever),
  );

  // 4. GARANTIR VISIBILIDADE DO BOTÃO: Mesmo com o texto visível, 
  // o ícone de lixeira pode estar no limite da tela.
  await tester.ensureVisible(btnLixeira);
  await tester.pumpAndSettle();

  print('--- Excluindo conta de valor $valorTeste ---');
  await tester.tap(btnLixeira);
  
  // 5. Aguardar processamento (deletar + init + fetchSaldo)
  await tester.pumpAndSettle(const Duration(seconds: 5));

  // --- VALIDAÇÃO FINAL ---
  final saldoFinalTxt = tester.widget<Text>(find.byKey(const Key('valor_saldo_total'))).data!;
  double saldoFinal = double.parse(saldoFinalTxt.replaceAll(RegExp(r'[^0-9.]'), ''));

  print('Saldo Inicial: $saldoInicial | Saldo Final: $saldoFinal');

  // O saldo final deve ser exatamente igual ao saldo inicial
  expect(saldoFinal, equals(saldoInicial));
  
  // Verificação extra: a conta sumiu da tela?
  expect(find.text(descricaoTeste), findsNothing);

  print('--- TESTE CT-05 (EXCLUSÃO) FINALIZADO COM SUCESSO ---');
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

// --- NAVEGAÇÃO ---
await tester.tap(find.byIcon(Icons.menu));
await tester.pumpAndSettle();
await tester.tap(find.text('Adicionar conta'));
await tester.pumpAndSettle();

// Preenchimento fixo
await tester.tap(find.text('Nubank'));
await tester.tap(find.text('Athos'));
await tester.tap(find.byType(TextFormField).at(0)); // Data
await tester.pumpAndSettle();
await tester.tap(find.text('18'));
await tester.tap(find.text('OK'));
await tester.pumpAndSettle();

// --- PASSO 1: Valor '0' (Inválido) ---
await tester.enterText(find.byType(TextFormField).at(1), 'Lanche');
await tester.enterText(find.byType(TextFormField).at(2), '0');

// FECHAR TECLADO DE FORMA AGRESSIVA
await tester.testTextInput.receiveAction(TextInputAction.done);
FocusManager.instance.primaryFocus?.unfocus(); // <--- Força a saída do foco
await tester.pumpAndSettle();

// GARANTIR QUE O BOTÃO ESTÁ VISÍVEL
final finderBotao = find.widgetWithText(ElevatedButton, 'Adicionar');
await tester.ensureVisible(finderBotao);
await tester.pumpAndSettle();

await tester.tap(finderBotao, warnIfMissed: false);

await tester.pump();

// VERIFICAÇÃO DA MENSAGEM DE ERRO
expect(
  find.textContaining('Insira um valor numérico válido e maior que 0.00'), 
  findsOneWidget,
  reason: "A mensagem de validação do SnackBar deveria aparecer."
);

// IMPORTANTE: Aguardar o SnackBar desaparecer para não bloquear o próximo clique
// Se o seu SnackBar dura 4 segundos, aguardamos 5 para garantir.
print('Aguardando SnackBar sumir...');
await tester.pumpAndSettle(const Duration(seconds: 10));

final campoValor = find.byType(TextFormField).at(2);

// 2. Garanta que ele esteja visível e clique nele para dar foco antes de digitar
await tester.ensureVisible(campoValor);
await tester.tap(campoValor); 
await tester.pumpAndSettle();

// --- PASSO 2: Valor '0.01' (Válido) ---
await tester.enterText(campoValor, '0.01');

final TextFormField widgetValor = tester.widget(campoValor);
print('Valor no campo agora: ${widgetValor.controller?.text}');
await tester.testTextInput.receiveAction(TextInputAction.done);
await tester.pumpAndSettle();

await tester.pumpAndSettle(const Duration(seconds: 10));

// Garante que o botão está visível (evita o erro de Hit Test)
final btnAdicionar = find.text('Adicionar');
await tester.ensureVisible(btnAdicionar);
await tester.pumpAndSettle();

await tester.tap(btnAdicionar);

// Aguarda a resposta da API e a navegação de volta para a Dashboard
await tester.pumpAndSettle(const Duration(seconds: 3));

// VERIFICAÇÃO FINAL: Voltou para a Dashboard?
expect(find.text('Saldo Total'), findsOneWidget);

print('--- TESTE CT-06 VALOR LIMITE ACEITO COM SUCESSO ---');
});

}