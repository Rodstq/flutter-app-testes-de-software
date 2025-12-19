import 'package:flutter_test/flutter_test.dart';
import 'package:contasflutter/viewmodel/add_conta_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

// Criamos a classe Mock
class MockClient extends Mock implements http.Client {}

void main() {
  late AddContaViewModel viewModel;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    // Injetamos o mock no ViewModel
    viewModel = AddContaViewModel(client: mockClient);
    
    // Configuração necessária para o mocktail aceitar Uri
    registerFallbackValue(Uri());
  });

  group('AddContaViewModel Mock Tests', () {
    
    test('Deve completar com sucesso quando o servidor retorna 201', () async {
      // Arrange (Configura o servidor falso para retornar 201)
      when(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{"message": "Sucesso"}', 201));

      // Act
      await viewModel.onAdicionarConta(
        origem: 'Nubank',
        dono: 1,
        data: DateTime.now(),
        descricao: 'Teste',
        valor: 10.0,
        token: 'token_valido'
      );

      // Assert (Verifica se o post foi chamado exatamente uma vez)
      verify(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body'))).called(1);
    });

    test('Deve tratar erro de conexão (ClientException) simulado', () async {
      // Arrange
      when(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenThrow(http.ClientException('Erro de rede'));

      // Act & Assert
      // Use "await" antes do expect e coloque a chamada dentro de uma função anônima
      await expectLater(
        () => viewModel.enviarConta(null, 'token'),
        throwsA(isA<http.ClientException>()),
      );
    });
  });
}