import 'package:contasflutter/data/model/conta_model.dart';
import 'package:contasflutter/viewmodel/Login_view_model.dart';
import 'package:contasflutter/viewmodel/add_conta_view_model.dart';
import 'package:contasflutter/viewmodel/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin{

  late TabController _tabController;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);

    if (loginVM.user != null) {
      dashboardVM.init(loginVM.user!.id!, loginVM.user!.token);
    }
  });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    DashboardViewModel dashboardViewModel = context.watch<DashboardViewModel>();
    LoginViewModel loginViewModel = context.watch<LoginViewModel>();
    AddContaViewModel addcontaViewModel = context.watch<AddContaViewModel>();

    if (_tabController.length != dashboardViewModel.origens.length) {
      // Descartamos o controller antigo para não vazar memória.
      _tabController.dispose();
      _tabController = TabController(
        length: dashboardViewModel.origens.length,
        vsync: this,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá! ${loginViewModel.user?.name}'),
        actions: [
          IconButton(
            onPressed: () async {
              await dashboardViewModel.init(loginViewModel.user!.id!,loginViewModel.user!.token);

              loginViewModel.fetchSaldo(loginViewModel.user!.token);

              loginViewModel.fetchSaldo(loginViewModel.user!.token);

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
              title: const Text('Todas as Contas'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/todas_contas');
              },
            ),

            ListTile(
              leading: const Icon(Icons.post_add_sharp),
              title: const Text('Adicionar conta'),
              onTap: () {

                
                addcontaViewModel.reset();
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
                            '${loginViewModel.user!.saldo}',
                            key: const Key('valor_saldo_total'),
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
                            '\$${dashboardViewModel.total}',
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
                  if (dashboardViewModel.origens.isNotEmpty)
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      labelColor: Colors.purple,
                      tabs: dashboardViewModel.origens.map((origem) {
                        return Tab(text: origem);
                      }).toList(),
                    )
                  else
                  // Mostra um placeholder enquanto as abas carregam
                  Container(height: 48),

                  Expanded(
                    child: dashboardViewModel.origens.isEmpty
                        ? Center(
                            child: dashboardViewModel.isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Nenhuma conta encontrada.\nClique no ícone para recarregar.',
                                    textAlign: TextAlign.center,
                                  ),
                          )
                        : 
                          TabBarView(
                            controller: _tabController,
                            children: dashboardViewModel.origens.map((origem) {
                              // Filtra a lista de contas para cada aba
                              final contasDaOrigem = dashboardViewModel
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
                                    width: 400,
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
                                      shrinkWrap: true,
                                      itemCount: contasDaOrigem.length,
                                      itemBuilder: (context, index) {
                                        final conta = contasDaOrigem[index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(conta.descricao ?? ''),
                                            subtitle: Text(
                                                '${conta.donoName} - ${conta.data}'),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'R\$ ${conta.valor?.toStringAsFixed(2) ?? 0.00}',
                                                  key: const Key('valor_conta_excluida'),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                IconButton(
                                                  onPressed: () async {

                                                   await addcontaViewModel.deletarConta(conta,loginViewModel.user!.token);

                                                   await dashboardViewModel.init(loginViewModel.user!.id!,loginViewModel.user!.token);

                                                   await loginViewModel.fetchSaldo(loginViewModel.user!.token);

                                                  }, 
                                                  icon: Icon(Icons.delete_forever)
                                                )
                                              ],
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
