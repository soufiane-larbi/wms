import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/helper/provider/zone_provider.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int? _category, _zone;
  List<DropdownMenuItem<int>>? _dropdownCategory, _dropdownZone;

  @override
  void initState() {
    super.initState();
    _dropdownCategory = context
        .read<CategoryProvider>()
        .categoryList
        .map<DropdownMenuItem<int>>((e) {
      return DropdownMenuItem<int>(
        value: e['id'],
        child: Text(e['name']),
      );
    }).toList();
    _category = _dropdownCategory![0].value;

    _dropdownZone = context
        .read<ZoneProvider>()
        .categoryList
        .map<DropdownMenuItem<int>>((e) {
      return DropdownMenuItem<int>(
        value: e['id'],
        child: Text(e['name']),
      );
    }).toList();
    _zone = _dropdownZone![0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Nom"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Categorie"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Model"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
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
                      height: 40,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _category,
                        onChanged: (var value) {
                          setState(() {
                            _category = value;
                          });
                        },
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 0,
                        underline: Container(
                          height: 0,
                        ),
                        items: _dropdownCategory,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                          controller: _modelController,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                          )),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("SKU"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Quantitie"),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Location"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _skuController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
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
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,6}')),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _zone,
                        onChanged: (var value) {
                          setState(() {
                            _zone = value;
                          });
                        },
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 0,
                        underline: Container(
                          height: 0,
                        ),
                        items: _dropdownZone,
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
                flex: 3,
                child: Container(
                  height: 30,
                  alignment: Alignment.topLeft,
                  child: const Text("Commentaire"),
                ),
              ),
              Expanded(
                flex: 17,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _skuController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
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
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              if (add()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${_nameController.text} a ??t?? ajouter avec succ??s",
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Le nom du produit et la quantit?? sont requis",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Ajouter'),
          ),
        ),
      ],
    );
  }

  bool add() {
    context.read<StockProvider>().query(
      query: '''INSERT INTO products(name,category,model,
        sku,quantity,remain,zone, creation_date,modified_date)
          VALUES(
            '${_nameController.text}',
            '$_category',
            '${_modelController.text}',
            '${_skuController.text}',
            ${_quantityController.text},
            ${_quantityController.text},
            $_zone,
            NOW(),
            NOW()
          );
        ''',
      filter: "where remain > 0 order by id desc",
    );
    return true;
  }
}
