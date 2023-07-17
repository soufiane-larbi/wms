import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/category_type.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/notification_provider.dart';

class AddCategory extends StatefulWidget {
  CategoryType? categoryOld;
  AddCategory({this.categoryOld, Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  FilePickerResult? _image;
  @override
  void initState() {
    if (widget.categoryOld != null) {
      _nameController.text = widget.categoryOld!.name!;
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
                child: const Text("Categorie"),
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
                    hintText: "Nom du categorie",
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: const Text("Image"),
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
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  controller: _imageController,
                  readOnly: true,
                  onTap: () async {
                    _image = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    setState(() {});
                  },
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        _image?.names[0] ?? "Clickez pour la selection d'image",
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
                        Navigator.of(context).pop();
                        if (_nameController.text.isEmpty) {
                          context.read<NotificationProvider>().showNotification(
                                message:
                                    "Le nom de la catégorie ne doit pas être vide",
                                type: 0,
                              );
                          return;
                        }
                        widget.categoryOld == null
                            ? await context.read<CategoryProvider>().add(
                                  category: CategoryType(
                                    name: _nameController.text,
                                    image: _image != null
                                        ? Blob.fromBytes(
                                            await File(_image!.files[0].path!)
                                                .readAsBytes())
                                        : null,
                                  ),
                                  context: context,
                                )
                            : await context.read<CategoryProvider>().edit(
                                  categoryOld: widget.categoryOld!,
                                  categoryNew: CategoryType(
                                    name: _nameController.text,
                                    image: _image != null
                                        ? Blob.fromBytes(
                                            await File(_image!.files[0].path!)
                                                .readAsBytes())
                                        : null,
                                  ),
                                  context: context,
                                );
                      },
                      child: Text(
                          widget.categoryOld == null ? 'Ajouter' : 'Modifié'),
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
