import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _pdrHint = 'Code Article',
      _pdrName = 'Désignation',
      _pdrPrice = '0 DZD',
      _pdrProduct = 'Produit Applicable',
      _pdrQuantity = '0';

  // @override
  // void initState() {
  //   super.initState();
  //   _dropdownCategory = context
  //       .read<CategoryProvider>()
  //       .categoryList
  //       .map<DropdownMenuItem<int>>((e) {
  //     return DropdownMenuItem<int>(
  //       value: e['id'],
  //       child: Text(e['name']),
  //     );
  //   }).toList();
  //   _category = _dropdownCategory![0].value;
  //   _dropdownModel = context
  //       .read<ModelProvider>()
  //       .categoryList
  //       .map<DropdownMenuItem<int>>((e) {
  //     return DropdownMenuItem<int>(
  //       value: e['id'],
  //       child: Text(e['name']),
  //     );
  //   }).toList();
  //   _model = _dropdownModel![0].value;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Code Article"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _idController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _pdrHint,
                    hintStyle: TextStyle(
                      color: _pdrHint.contains('Exsiste') ||
                              _pdrHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Désignation"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nameController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _pdrName,
                    hintStyle: TextStyle(
                      color: _pdrHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Prix"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _priceController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _pdrPrice,
                    hintStyle: TextStyle(
                      color: _pdrHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,6}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Produit"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _productController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _pdrProduct,
                    hintStyle: TextStyle(
                      color: _pdrHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Quantite"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _quantityController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _pdrQuantity,
                    hintStyle: TextStyle(
                      color: _pdrHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'\d{0,6}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        int result = await add();
                        if (result == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${_nameController.text} a été ajouter avec succès.",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                          return;
                        }
                        if (result == 1) {
                          setState(() {
                            _pdrHint = "Code Article Est Requis";
                            _pdrName = "Designation Est Requis";
                            _pdrQuantity = "Quantity Est Requis";
                            _pdrPrice = "Price Est Requis";
                            _pdrProduct = "Produit Applicable Est Requis";
                          });
                          return;
                        }
                        setState(() {
                          _pdrHint = "${_idController.text} exsiste deja.";
                          _idController.text = '';
                        });
                      },
                      child: const Text('Ajouter'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<int> add() async {
    int ret = 0;
    if (_nameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _productController.text.isEmpty ||
        _idController.text.isEmpty) {
      return 1;
    }
    await context
        .read<StockProvider>()
        .addStock(
          name: _nameController.text,
          product: _productController.text,
          id: _idController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
        )
        .then(
      (added) async {
        if (added) {
          await context.read<HistoryProvider>().addHistory(
                user: await context.read<UserProvider>().user,
                pdr: _idController.text,
                operation: "Ajouter",
                newQuantity: int.parse(_quantityController.text),
                previousQuantity: 0,
              );
          return;
        }
        ret = 2;
      },
    );
    return ret;
  }
}
