import 'package:contasflutter/data/model/conta_model.dart';
import 'package:contasflutter/viewmodel/Login_view_model.dart';
import 'package:contasflutter/viewmodel/todas_contas_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodasContas extends StatefulWidget {
  const TodasContas({super.key});

  @override
  State<TodasContas> createState() => _TodasContasState();
}

class _TodasContasState extends State<TodasContas> with TickerProviderStateMixin{

  late TabController _tabController;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Inicializamos com um controller "vazio" para evitar erros no primeiro frame.
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    TodasContasViewModel todasContasViewModel = context.watch<TodasContasViewModel>();
    LoginViewModel loginViewModel = context.watch<LoginViewModel>();

    if (_tabController.length != todasContasViewModel.origens.length) {
      // Descartamos o controller antigo para não vazar memória.
      _tabController.dispose();
      _tabController = TabController(
        length: todasContasViewModel.origens.length,
        vsync: this,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá! ${loginViewModel.user?.name}'),
        actions: [
          IconButton(
            onPressed: () async {
              await todasContasViewModel.init(loginViewModel.user!.token);
            },
            icon: Icon(Icons.replay_outlined),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(color: Colors.purple[900]),
              child: Text(
                'Contas',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Meu Dashboard'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/dashboard');
              },
            ),

            ListTile(
              leading: const Icon(Icons.post_add_sharp),
              title: const Text('Adicionar conta'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/add_conta');
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.purple[900],
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Saldo Total',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${loginViewModel.saldoTemporario}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      VerticalDivider(
                        color: const Color.fromARGB(255, 245, 244, 244),
                        thickness: 2,
                        width: 20,
                      ),

                      Column(
                        children: [
                          Text(
                            'Despesas totais',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '\$${todasContasViewModel.total}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        color: Colors.purple[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: 0.30,
                                  backgroundColor: Colors.purple[700],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                  minHeight: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              'Salário Mensal: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${loginViewModel.user?.salario}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ElevatedButton(
                      //   onPressed: () async {

                      //     await TodasContasViewModel.init();

                      //     loginViewModel.setSaldo(TodasContasViewModel.total);

                      //   },
                      //   child: Text('Atualizar contas'))
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  if (todasContasViewModel.origens.isNotEmpty)
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      labelColor: Colors.purple,
                      tabs: todasContasViewModel.origens.map((origem) {
                        return Tab(text: origem);
                      }).toList(),
                    )
                  else
                  // Mostra um placeholder enquanto as abas carregam
                  Text('todas as contas'),
                  Container(height: 48),
                  Expanded(
                    child: todasContasViewModel.origens.isEmpty
                        ? Center(
                            child: todasContasViewModel.isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Nenhuma cota encontrada.\nClique no ícone para recarregar.',
                                    textAlign: TextAlign.center,
                                  ),
                          )
                        : 
                          TabBarView(
                            controller: _tabController,
                            children: todasContasViewModel.origens.map((origem) {
                              // Filtra a lista de contas para cada aba
                              final contasDaOrigem = todasContasViewModel
                                  .contasFuture
                                  ?.where((c) => c.origem == origem)
                                  .toList() ?? [];

                              if (contasDaOrigem.isEmpty) {
                                return Center(
                                    child: Text('Nenhuma conta para $origem'));
                              }

                              return Column(
                                children: [

                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(top: 10),
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:  Colors.purple[900],                              
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Total de ${origem}:',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          Text(' ${_contasDaOrigem(contasDaOrigem)}',style: TextStyle(color: Colors.white),),
                                        ],
                                      )
                                    ),

                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: contasDaOrigem.length,
                                      itemBuilder: (context, index) {
                                        final conta = contasDaOrigem[index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(conta.descricao ?? ''),
                                            subtitle: Text(
                                                '${conta.donoName} - ${conta.data}'),
                                            trailing: Text(
                                              'R\$ ${conta.valor?.toStringAsFixed(2) ?? 0.00}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                  )
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

 String _contasDaOrigem(List<Conta> contas){
  double total = 0;
    for(Conta conta in contas){
      if (conta.valor != null){
        total += conta.valor! ;
      }
    }
    return total.toString();
  }
}
