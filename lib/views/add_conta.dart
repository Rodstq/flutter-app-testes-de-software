import 'package:contasflutter/viewmodel/add_conta_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddConta extends StatefulWidget {
  const AddConta({super.key});

  @override
  State<AddConta> createState() => _AddContaState();
}

class _AddContaState extends State<AddConta> {

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    AddContaViewModel addcontaViewModel = context.watch<AddContaViewModel>();

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Despesa')),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Origem:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Nubank',
                            groupValue: addcontaViewModel.origem,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setOrigem(value);
                              });
                            },
                          ),
                          Text(
                            'Nubank',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Inter',
                            groupValue: addcontaViewModel.origem,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setOrigem(value);
                              });
                            },
                          ),
                          Text(
                            'Inter',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Radio<String>(
                            value: 'Bradesco',
                            groupValue: addcontaViewModel.origem,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setOrigem(value);
                              });
                            },
                          ),
                          Text(
                            'Bradesco',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
 ],
                  ),

                  Row(
                    children: [
                       Row(
                        children: [
                          Radio<String>(
                            value:'Itau',
                            groupValue: addcontaViewModel.origem,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setOrigem(value);
                              });
                            },
                          ),
                          Text(
                            'Itau',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                       Row(
                        children: [
                          Radio<String>(
                            value: 'Debito',
                            groupValue: addcontaViewModel.origem,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setOrigem(value);
                              });
                            },
                          ),
                          Text(
                            'Debito',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                ],
                  ),
                ],
              ),

              Text(
                'Dono',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  Row(
                        children: [
                          Radio<int>(
                            value:1,
                            groupValue: addcontaViewModel.dono,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setDono(value);
                              });
                            },
                          ),
                          Text(
                            'Athos',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  Row(
                        children: [
                          Radio<int>(
                            value:2,
                            groupValue: addcontaViewModel.dono,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setDono(value);
                              });
                            },
                          ),
                          Text(
                            'Renata',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  Row(
                        children: [
                          Radio<int>(
                            value:3,
                            groupValue: addcontaViewModel.dono,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                addcontaViewModel.setDono(value);
                              });
                            },
                          ),
                          Text(
                            'Os Dois',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                ],
              ),

              const SizedBox(height: 16),
              
              Text(
                'Data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                 await _showDatePicker(context, addcontaViewModel);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Descricão',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _descController,
                onChanged: (value) {
                  setState(() {
                    _descController.text = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Valor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                keyboardType: TextInputType.number,
                // This is the key part for enforcement
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+([,.])?\d{0,2}')),
                ],
                controller: _valorController,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _valorController.text = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: screenWidth,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                   await addcontaViewModel.onAdicionarConta(origem: addcontaViewModel.origem, data: addcontaViewModel.data, descricao: _descController.text, dono: addcontaViewModel.dono, valor: double.tryParse(_valorController.text));

                   Navigator.pop(context);
                  },
                  child: Text('Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, AddContaViewModel addcontaViewModel) async {

    DateTime? data = await showDatePicker(context: context, firstDate: DateTime(2025), lastDate: DateTime.now());

    addcontaViewModel.setData(data);

    if (data != null){
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(data);
        _dateController.text = formattedDate;
      });
    }
  }

}
