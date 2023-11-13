import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:minhas_financas/Database/database_Helper.dart';
import 'package:minhas_financas/Models/Models.dart';
import 'package:minhas_financas/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DataManagementScreen extends StatefulWidget {
  @override
  _DataManagementScreenState createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _parcelaController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _carteiraIdController = TextEditingController();
  final TextEditingController _usuarioIdController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _origemController = TextEditingController();
  late int userId;
  var l_Database = DatabaseHelper.instance;
  late List<FinancialData> financialDataList = [];
  late String total = "";
  String filter = "";
  @override
  void dispose() {
    _descricaoController.dispose();
    _mesController.dispose();
    _valorController.dispose();
    _parcelaController.dispose();
    _subtotalController.dispose();
    _itemIdController.dispose();
    _carteiraIdController.dispose();
    _usuarioIdController.dispose();
    _dataController.dispose();
    _origemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadUserId();
    setState(() {
      ObterItens().then((result) {
        financialDataList.clear();
        for (var item in result) {
          financialDataList.add(item);
        }
      });
      CalcularTotal();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Financeiros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira uma descrição para o item';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira o valor';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _origemController,
                    decoration: InputDecoration(
                      labelText: 'Origem do débito',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira uma origem para o item';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _parcelaController,
                    decoration: InputDecoration(
                      labelText: 'Parcela',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira uma parcela para o item';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final descricao = _descricaoController.text;
                        final valor = double.parse(_valorController.text);
                        final mes = DateTime.now().month;
                        String data =
                            DateFormat("dd/MM/yyyy").format(DateTime.now());
                        int parcela = int.parse(_parcelaController.text);
                        double subtotal =
                            ((parcela == null || parcela == '' ? 0 : parcela) *
                                valor);
                        int novaParcela = 0;
                        // _itemIdController.text =
                        //     DateTime.fromMillisecondsSinceEpoch.toString();
                        loadUserId();
                        _carteiraIdController.text = userId.toString();
                        _usuarioIdController.text = userId.toString();
                        final origem = _origemController.text;
                        // final itemId = int.parse(_itemIdController.text);
                        final carteiraId =
                            int.parse(_carteiraIdController.text);
                        final usuarioId = int.parse(_usuarioIdController.text);
                        final newFinancialData = FinancialData(
                            descricao,
                            valor,
                            mes.toString(),
                            data as String,
                            parcela,
                            subtotal,
                            // itemId,
                            carteiraId,
                            usuarioId,
                            origem);

                        setState(() {
                          financialDataList.add(newFinancialData);
                          Map<String, dynamic> row = {
                            model_Item.columnMes: mes,
                            model_Item.columnData: data,
                            model_Item.columnValor: valor,
                            model_Item.columnParcela: parcela,
                            model_Item.columnDescricao: descricao,
                            model_Item.columnSubTotal: subtotal,
                            // model_Item.columnItemId:
                            //     this._itemIdController.text,
                            model_Item.columnCarteiraId: carteiraId,
                            model_Item.columnUsuarioId: usuarioId,
                            model_Item.columnOrigem: origem
                          };
                          l_Database.insertItem(row);
                        });
                        if (parcela > 1) {
                          for (int i = 1; i < parcela; i++) {
                            var dataConvertida = data.split('/');
                            int l_Ano = int.parse(dataConvertida[2]);
                            int l_Mes = int.parse(dataConvertida[1]);
                            int l_Data = int.parse(dataConvertida[0]);
                            l_Mes++;
                            if (l_Mes > 12) {
                              l_Ano++;
                              l_Mes = 01;
                            }
                            DateTime novaData = DateTime(l_Ano, l_Mes, l_Data);
                            setState(() {
                              data = DateFormat("dd/MM/yyyy").format(novaData);
                              subtotal -= valor;
                              novaParcela = parcela - i;
                            });

                            FinancialData ItensParcelados = FinancialData(
                                descricao,
                                valor,
                                DateFormat('MM').format(novaData),
                                DateFormat("dd/MM/yyyy").format(novaData),
                                novaParcela,
                                subtotal,
                                // itemId,
                                carteiraId,
                                usuarioId,
                                origem);
                            financialDataList.add(ItensParcelados);

                            setState(() {
                              Map<String, dynamic> row = {
                                model_Item.columnMes:
                                    DateFormat('MM').format(novaData),
                                model_Item.columnData:
                                    DateFormat("dd/MM/yyyy").format(novaData),
                                model_Item.columnValor: valor,
                                model_Item.columnParcela: novaParcela,
                                model_Item.columnDescricao: descricao,
                                model_Item.columnSubTotal: subtotal,
                                // model_Item.columnItemId:
                                //     this._itemIdController.text,
                                model_Item.columnCarteiraId: carteiraId,
                                model_Item.columnUsuarioId: usuarioId,
                                model_Item.columnOrigem: origem
                              };
                              l_Database.insertItem(row);
                            });
                          }
                        }
                        _descricaoController.clear();
                        _valorController.clear();
                        _parcelaController.clear();
                        _mesController.clear();
                        _dataController.clear();
                        _filterController.clear();
                        _origemController.clear();

                        setState(() {
                          financialDataList.clear();
                          ObterItens().then((result) {
                            financialDataList.addAll(result);
                            financialDataList
                                .where((m) => m.mes == _filterController.text);
                            CalcularTotal();
                          });
                        });
                      }
                    },
                    child: Text('Adicionar Dados'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text('Dados Financeiros :'),
            Container(
              child: TextFormField(
                controller: _filterController,
                decoration: InputDecoration(
                  labelText: 'Filtro mês',
                ),
                onTap: () => CalcularTotal(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      // DataColumn(label: Text('Mês')),
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Valor')),
                      DataColumn(label: Text('Origem')),
                      DataColumn(label: Text('Data / Hora')),
                      DataColumn(label: Text('Parcela')),
                      DataColumn(label: Text('Sub-total')),
                      DataColumn(label: Text("")),
                    ],
                    rows: financialDataList
                        .where((m) => m.mes.contains(_filterController.text))
                        .map((data) {
                      return DataRow(cells: [
                        // DataCell(Text(data.mes)),
                        DataCell(Text(data.descricao)),
                        DataCell(Text('R\$${data.valor.toStringAsFixed(2)}')),
                        DataCell(Text(data.origem)),
                        DataCell(Text(data.data)),
                        DataCell(Text(data.parcela.toString())),
                        DataCell(
                            Text('R\$${data.subtotal.toStringAsFixed(2)}')),
                        DataCell(
                          Icon(
                            Icons.remove_circle_outlined,
                            color: Colors.redAccent,
                            size: 24.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          onTap: () => l_Database.delete(data.itemId),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
            Text(
              total,
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }

  // ReplicarDebitosPorParcela(FinancialData a_Item) {
  //   if (a_Item.parcela > 0) {
  //     FinancialData l_FinancialData = FinancialData();
  //   }
  // }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('user_id');
    setState(() {
      userId = storedUserId!;
    });
  }

  Future<int> ObterUserIdLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('user_id');
    return storedUserId!;
  }

  Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
  }

  Future<Iterable<FinancialData>> ObterItens() async {
    var lItens = await l_Database.getItensPorUsuarioId(userId);
    List<FinancialData> lRetorno = [];
    for (var item in lItens.toList()) {
      lRetorno.add(item);
    }
    return lRetorno;
  }

  void CalcularTotal() {
    double _total = 0;
    var listaFiltrada = financialDataList
        .where((element) => element.mes.contains(_filterController.text));
    for (var item in listaFiltrada.toList()) {
      _total += item.subtotal;
    }
    setState(() {
      total = 'Débitos totais R\$${_total.toStringAsFixed(2)}';
    });
  }
}
