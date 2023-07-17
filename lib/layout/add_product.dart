import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/category_type.dart';
import 'package:whm/Formater/product_type.dart';
import 'package:whm/Formater/warehouse_type.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/notification_provider.dart';
import 'package:whm/helper/provider/product_provider.dart';
import 'package:whm/helper/provider/warehouse_provider.dart';

class AddStock extends StatefulWidget {
  ProductType? productOld;
  AddStock({
    Key? key,
    this.productOld,
  }) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  FilePickerResult? _imagePath;
  Uint8List? _image;
  late List<CategoryType> _categories;
  late List<WarehouseType> _warehouse;
  CategoryType? _selectedCategory;
  WarehouseType? _selectedWarehouse;
  final String _nameHint = 'Nom du produit',
      _barcodeHint = 'CodeBarre',
      _quantityHint = '0.0',
      _unitHint = 'Unite';
  bool _edit = false;

  @override
  void initState() {
    _categories = context.read<CategoryProvider>().categoryList;
    _warehouse = context.read<WarehouseProvider>().wahrehouseList;
    _selectedCategory = _categories.first;
    _selectedWarehouse = _warehouse.first;
    if (widget.productOld != null) {
      _nameController.text = widget.productOld!.name ?? '';
      _unitController.text = widget.productOld!.unit ?? '';
      _barcodeController.text = widget.productOld!.barcode ?? '';
      _quantityController.text = "${widget.productOld!.quantity ?? ''}";
      _selectedCategory = widget.productOld!.category;
      _selectedWarehouse = widget.productOld!.warehouse;
      _edit = true;
    }

    super.initState();
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
                child: const Text("Produit"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 255,
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
                    hintText: _nameHint,
                    hintStyle: TextStyle(
                      color: _nameHint.contains('Exsiste') ||
                              _nameHint.contains('Est Requis')
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () async {
                  _imagePath = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.image,
                  );
                  _image = await File(_imagePath!.files[0].path!).readAsBytes();
                  setState(() {});
                },
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imagePath != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        )
                      : _edit && widget.productOld!.image != null
                          ? Image.memory(
                              widget.productOld!.image!.toBytes() as Uint8List,
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[800],
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
                child: const Text("Code a barre"),
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
                  controller: _barcodeController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _barcodeHint,
                    hintStyle: TextStyle(
                      color: _barcodeHint.contains('Est Requis')
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
                width: 140,
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
                    hintText: _quantityHint,
                    hintStyle: TextStyle(
                      color: _quantityHint.contains('Est Requis')
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
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 150,
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: const Text("Unite"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _unitController,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _unitHint,
                            hintStyle: TextStyle(
                              color: _unitHint.contains('Est Requis')
                                  ? Colors.red
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
                child: const Text("Categorie"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: category(items: _categories),
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
                child: const Text("Depot"),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: warehouse(items: _warehouse),
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
                      onPressed: () {
                        add();
                      },
                      child: Text(_edit ? 'Modifier' : 'Ajouter'),
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

  Widget category({required items}) {
    return DropdownButton<CategoryType>(
      underline: Container(),
      alignment: Alignment.center,
      items: context
          .read<CategoryProvider>()
          .categoryList
          .map<DropdownMenuItem<CategoryType>>((CategoryType item) {
        return DropdownMenuItem(value: item, child: Text(item.name!));
      }).toList(),
      onChanged: (item) {
        setState(() {
          _selectedCategory = item!;
        });
      },
      value: _selectedCategory,
    );
  }

  Widget warehouse({required items}) {
    return DropdownButton<WarehouseType>(
      underline: Container(),
      alignment: Alignment.center,
      items: context
          .read<WarehouseProvider>()
          .wahrehouseList
          .map<DropdownMenuItem<WarehouseType>>((WarehouseType item) {
        return DropdownMenuItem(value: item, child: Text(item.name!));
      }).toList(),
      onChanged: (item) {
        setState(() {
          _selectedWarehouse = item;
        });
      },
      value: _selectedWarehouse,
    );
  }

  void add() async {
    if (_nameController.text == '' ||
        _quantityController.text == '' ||
        _unitController.text == '') {
      context.read<NotificationProvider>().showNotification(
            type: 1,
            message: "Veuillez remplir tous les champs obligatoires",
          );
      return;
    }
    Navigator.of(context).pop();
    _edit
        ? await context.read<ProductProvider>().edit(
              context: context,
              productNew: ProductType(
                name: _nameController.text,
                barcode: _barcodeController.text,
                quantity: double.parse(_quantityController.text),
                unit: _unitController.text,
                warehouse: _selectedWarehouse,
                category: _selectedCategory,
                image: _imagePath != null
                    ? Blob.fromBytes(
                        await File(_imagePath!.files[0].path!).readAsBytes())
                    : null,
              ),
              productOld: widget.productOld,
            )
        : await context.read<ProductProvider>().add(
              context: context,
              product: ProductType(
                name: _nameController.text,
                barcode: _barcodeController.text,
                quantity: double.parse(_quantityController.text),
                unit: _unitController.text,
                image: _imagePath != null
                    ? Blob.fromBytes(
                        await File(_imagePath!.files[0].path!).readAsBytes())
                    : null,
                warehouse: _selectedWarehouse,
                category: _selectedCategory,
              ),
            );
  }
}
