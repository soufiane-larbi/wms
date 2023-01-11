import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/helper/provider/bon_provider.dart';
import 'package:whm/helper/provider/history_provider.dart';

import '../helper/provider/stock_provider.dart';

class EditPDR extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final pdr;
  const EditPDR({
    Key? key,
    required this.pdr,
  }) : super(key: key);

  @override
  State<EditPDR> createState() => _EditPDRState();
}

class _EditPDRState extends State<EditPDR> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _quantityHint = 'Quantitie',
      _productHint = 'Produit',
      _nameHint = 'Désignation',
      _priceHint = '0.0 DZD',
      _idHint = 'Code Article';
  @override
  void initState() {
    super.initState();
    _idController.text = widget.pdr['id'];
    _priceController.text = widget.pdr['price'].toString();
    _quantityController.text = widget.pdr['quantity'].toString();
    _productController.text = widget.pdr['product'];
    _nameController.text = widget.pdr['name'];
  }

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
                    hintText: _idHint,
                    hintStyle: TextStyle(
                      color: _productHint.contains('Est Requis')
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
                  enabled: context.read<BonProvider>().temBonList.isEmpty,
                  controller: _productController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _nameHint,
                    hintStyle: TextStyle(
                      color: _productHint.contains('Est Requis')
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
                child: const Text("Product"),
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
                    enabled: context.read<BonProvider>().temBonList.isEmpty,
                    controller: _nameController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _productHint,
                      hintStyle: TextStyle(
                        color: _nameHint.contains('Est Requis')
                            ? Colors.red
                            : Colors.grey[700],
                      ),
                    )),
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
              SizedBox(
                height: 40,
                width: 300,
                child: Container(
                  height: 40,
                  width: 300,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    enabled: widget.pdr['price'] == 0.0 || AppConfig.isAdmin,
                    controller: _priceController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _priceHint,
                      hintStyle: TextStyle(
                        color: _productHint.contains('Est Requis')
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
                  enabled: AppConfig.isAdmin,
                  controller: _quantityController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _quantityHint,
                    hintStyle: TextStyle(
                      color: _quantityHint.contains('Est Requis')
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
                        int result = await update();
                        if (result == -2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Aucune modification appliquée à ${_nameController.text}",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          Navigator.of(context).pop();
                          return;
                        }
                        if (result == -1) {
                          setState(() {
                            _quantityHint = 'Quantitie Est Requis';
                            _productHint = 'Produit Est Requis';
                            _nameHint = 'Désignation Est Requis';
                            _idHint = 'Code Article Est Requis';
                            _priceHint = 'Prix Est Requis';
                          });
                          return;
                        }
                        if (result == 0) {
                          setState(() {
                            _idHint = "${_idController.text} existe déjà";
                            _idController.text = '';
                          });
                          return;
                        }
                        if (result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${_nameController.text} a été modifié.",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Modifié'),
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

  Future<int> update() async {
    //All fields are required Error: -1
    if (_idController.text.isEmpty) return -1;
    if (_nameController.text.isEmpty) return -1;
    if (_productController.text.isEmpty) return -1;
    if (_quantityController.text.isEmpty) return -1;
    if (_priceController.text.isEmpty) return -1;
    //Nothing Changes Error: -2
    String updatedValues = 'Modifier:'
        '${_idController.text.compareTo(widget.pdr['id']) == 0 ? '' : ' ${widget.pdr['id']}:${_idController.text}'}'
        '${_nameController.text.compareTo(widget.pdr['name']) == 0 ? '' : ' ${widget.pdr['name']}:${_nameController.text}'}'
        '${_productController.text.compareTo(widget.pdr['product']) == 0 ? '' : ' ${widget.pdr['product']}:${_productController.text}'}'
        '${widget.pdr['price'] == double.parse(_priceController.text) ? '' : ' ${widget.pdr['price']}:${_priceController.text}'}'
        '${widget.pdr['quantity'] == int.parse(_quantityController.text) ? '' : ' ${widget.pdr['quantity']}:${_quantityController.text}'}';
    if (!updatedValues.contains(' ')) return -2;

    int result = await context.read<StockProvider>().updatePDR(
          id: widget.pdr['id'],
          newId: _idController.text,
          name: _nameController.text,
          product: _productController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
        );

    context.read<HistoryProvider>().addHistory(
          user: AppConfig.user,
          pdr: _idController.text,
          operation: updatedValues,
          newQuantity: int.parse(_quantityController.text),
        );
    return result;
  }
}
