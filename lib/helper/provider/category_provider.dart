import 'dart:async';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/category_type.dart';
import 'package:whm/helper/config.dart';
import 'notification_provider.dart';

class CategoryProvider with ChangeNotifier {
  final List<CategoryType> _categoryList = [];
  int _selected = 0;
  int get selected => _selected;
  get categoryList => _categoryList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> reset({required BuildContext context, filter = ''}) async {
    _selected = 0;
    setList(context: context);
    notifyListeners();
  }

  Future<Object> setList({required BuildContext context, filter = ''}) async {
    try {
      _categoryList.clear();
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      final result = await conn.query('''
        SELECT * FROM category
        ${filter == '' ? '' : 'WHERE'}
        ORDER BY creation_date DESC;
        ''');
      conn.close();
      for (final row in result) {
        final category = CategoryType(
          id: row['id'],
          name: row['name'],
          image: row['image'],
          creationDate: row['creation_date'],
          modifiedDate: row['modified_date'],
        );
        _categoryList.add(category);
      }
      if (_selected > _categoryList.length - 1) {
        _selected = _categoryList.length - 1;
      }
      notifyListeners();
      return true;
    } on Exception catch (e) {
      context.read<NotificationProvider>().showNotification(
            message: e,
            type: 2,
          );
      return e;
    }
  }

  Future<Object> add(
      {required BuildContext context, required CategoryType category}) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String imageHex = category.image != null
          ? "0x${hex.encode(category.image!.toBytes())}"
          : "null";
      String q = '''
        INSERT INTO category(name,image) VALUES("${category.name}", $imageHex);
        ''';
      final result = await conn.query(q);
      conn.close();
      if (result.insertId! >= 0) {
        context.read<NotificationProvider>().showNotification(
              message: "le produit ${category.name} a été ajouté avec succès.",
              type: 0,
            );
        setList(context: context);
        return true;
      }

      context.read<NotificationProvider>().showNotification(
            message: "le produit ${category.name} a été ajouté avec succès.",
            type: 1,
          );
      return true;
    } on Exception catch (e) {
      context.read<NotificationProvider>().showNotification(
            message: e,
            type: 2,
          );
      return e;
    }
  }

  Future<Object> edit({
    required BuildContext context,
    required CategoryType categoryNew,
    required CategoryType categoryOld,
  }) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String imageHex = categoryNew.image != null
          ? "0x${hex.encode(categoryNew.image!.toBytes())}"
          : categoryOld.image != null
              ? "0x${hex.encode(categoryOld.image!.toBytes())}"
              : "null";
      String q = '''
        UPDATE category SET name = "${categoryNew.name}", image = $imageHex
        WHERE id = ${_categoryList[_selected].id};
        ''';
      String qNext = '''
        UPDATE category SET  modified_date = NOW() 
        WHERE id = ${_categoryList[_selected].id};
        ''';
      var result = await conn.query(q);
      if (result.affectedRows! > 0) {
        result = await conn.query(qNext);
        context.read<NotificationProvider>().showNotification(
              message:
                  "La catégorie ${categoryNew.name} a été modifié avec succès.",
              type: 0,
            );

        conn.close();
        setList(context: context);
        return true;
      }

      context.read<NotificationProvider>().showNotification(
            message: "Aucune nouvelle modification n'a été saisie",
            type: 1,
          );
      return false;
    } on Exception catch (e) {
      context.read<NotificationProvider>().showNotification(
            message: e,
            type: 2,
          );
      return e;
    }
  }

  Future<Object> delete({required BuildContext context}) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String q = '''
        SELECT * FROM product WHERE category = ${_categoryList[_selected].id};
        ''';
      var result = await conn.query(q);
      if (result.isNotEmpty) {
        context.read<NotificationProvider>().showNotification(
              message:
                  "La catégorie ${_categoryList[_selected].name} ne peut pas être supprimée (utilisée dans les produits)",
              type: 1,
            );
        return false;
      }
      q = '''
        DELETE FROM category WHERE id = ${_categoryList[_selected].id};
        ''';
      result = await conn.query(q);
      conn.close();
      if (result.affectedRows! >= 0) {
        context.read<NotificationProvider>().showNotification(
              message:
                  "La catégorie ${_categoryList[_selected].name} La catégorie X a été supprimée",
              type: 0,
            );
        setList(context: context);
        return true;
      }
      context.read<NotificationProvider>().showNotification(
            message:
                "La catégorie ${_categoryList[_selected].name} ne peut pas être supprimée!",
            type: 1,
          );
      return false;
    } on Exception catch (e) {
      context.read<NotificationProvider>().showNotification(
            message: e,
            type: 2,
          );
      return e;
    }
  }
}
