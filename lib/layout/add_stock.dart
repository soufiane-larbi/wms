import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _containerController = TextEditingController();
  final TextEditingController _recieveController = TextEditingController();
  final TextEditingController _madeController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _stockingController = TextEditingController();
  final TextEditingController _returnController = TextEditingController();
  final TextEditingController _brokenController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Produit"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Fournisseur"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Batch"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Recevoir"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Fabrication"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Retour"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                          controller: _nameController,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                          )),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                          controller: _providerController,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                          )),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                          controller: _batchController,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                          )),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _recieveController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "jj/mm/aaaa",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _madeController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _returnController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Type"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Conteneur"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Quantité"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Expiration"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Stockage"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Casse"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _typeController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _containerController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _quantityController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,6}')),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _expController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _stockingController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _brokenController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 120,
          width: double.maxFinite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 30,
                  alignment: Alignment.topLeft,
                  child: const Text("Commentaire"),
                ),
              ),
              Expanded(
                flex: 16,
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _commentController,
                    maxLines: 100,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              if (add()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${_nameController.text} a été ajouter avec succès",
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Le nom du produit et la quantité sont requis",
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Ajouter'),
          ),
        ),
      ],
    );
  }

  bool add() {
    if (_nameController.text == '' || _quantityController.text == '') {
      return false;
    }
    context.read<StockProvider>().setDB(
      query: '''insert into stock (name,type,provider,container,batch,quantity,remain,recieved_date,expiration_date,made_date,stocking_zone,return,broken,comment) 
      values(
        "${_nameController.text}","${_typeController.text}",
        "${_providerController.text}","${_containerController.text}",
        "${_batchController.text}",
        ${double.parse(_quantityController.text)},
        ${double.parse(_quantityController.text)},
        "${_recieveController.text}","${_expController.text}",
        "${_madeController.text}","${_stockingController.text}",
        ${double.parse(_returnController.text == '' ? '0' : _returnController.text)},
        ${double.parse(_brokenController.text == '' ? '0' : _returnController.text)},
        "${_commentController.text}"
      )''',
    );
    DateTime now = DateTime.now();
    context.read<HistoryProvider>().setDB(
      query: '''insert into history (name,type,provider,operation,date,time,stock,remain) 
      values(
        '${_nameController.text}','${_typeController.text}',
        '${_providerController.text}','${_quantityController.text}',
        '${now.day}/${now.month}/${now.year}','${now.hour}:${now.minute}',
        ${double.parse(_quantityController.text)},
        ${double.parse(_quantityController.text)}
      )''',
    );
    return true;
  }
}
