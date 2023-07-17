import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/warehouse_type.dart';
import 'package:whm/helper/provider/warehouse_provider.dart';

import '../helper/provider/notification_provider.dart';

class AddWarehouse extends StatefulWidget {
  WarehouseType? warehouse;
  AddWarehouse({this.warehouse, Key? key}) : super(key: key);

  @override
  State<AddWarehouse> createState() => _AddWarehouseState();
}

class _AddWarehouseState extends State<AddWarehouse> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _depotHint = 'Nom';
  bool _edit = false;

  @override
  void initState() {
    if (widget.warehouse != null) {
      _nameController.text = widget.warehouse!.name ?? "";
      _locationController.text = widget.warehouse!.location ?? "";
      _descriptionController.text = widget.warehouse!.description ?? "";
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
                child: const Text("Depot"),
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
                    hintText: _depotHint,
                    hintStyle: TextStyle(
                      color: _depotHint.contains('requis')
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
                child: const Text("Location"),
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
                  controller: _locationController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Location",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
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
                child: const Text("Description"),
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
                  controller: _descriptionController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Description",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
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
                        if (_nameController.text == "") {
                          setState(() {
                            _depotHint = "Le nom de l'entrepôt est requis";
                          });
                          return;
                        }
                        _edit
                            ? context.read<WarehouseProvider>().edit(
                                  context: context,
                                  name: _nameController.text,
                                  location: _locationController.text,
                                  description: _descriptionController.text,
                                )
                            : context.read<WarehouseProvider>().add(
                                  context: context,
                                  name: _nameController.text,
                                  location: _locationController.text,
                                  description: _descriptionController.text,
                                );
                        Navigator.of(context).pop();
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
}
