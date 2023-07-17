import 'dart:async';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/config.dart';
import '../../Formater/warehouse_type.dart';
import 'dart:io';

import 'notification_provider.dart';

class WarehouseProvider with ChangeNotifier {
  final List<WarehouseType> _warehouseList = [];
  int _selected = 0;
  int get selected => _selected;
  get wahrehouseList => _warehouseList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> reset({required context, contefilter = ''}) async {
    _selected = 0;
    setList(context: context);
    notifyListeners();
  }

  Future<Object> setList({required context, filter = ''}) async {
    try {
      _warehouseList.clear();
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      final result = await conn.query('''
        SELECT * FROM warehouse
        ${filter == '' ? '' : 'WHERE'}
        ORDER BY modified_date DESC;
        ''');
      conn.close();
      for (final row in result) {
        final warehouse = WarehouseType(
          id: row['id'],
          name: row['name'],
          location: row['location'],
          description: row['description'],
          creationDate: row['creation_date'],
          modifiedDate: row['modified_date'],
        );
        _warehouseList.add(warehouse);
      }
      if (_selected > _warehouseList.length - 1) {
        _selected = _warehouseList.length - 1;
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
      {required BuildContext context,
      name,
      location,
      description,
      File? image}) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String q = '''
        INSERT INTO warehouse(name, location, description)
        VALUES("$name", "$location", "$description");
        ''';
      final result = await conn.query(q);
      conn.close();
      if (result.insertId! >= 0) {
        setList(context: context);
        context.read<NotificationProvider>().showNotification(
              message: "L'entrepôt $name a été ajouté avec succès.",
              type: 0,
            );
        return true;
      }
      context.read<NotificationProvider>().showNotification(
            message: "L'entrepôt $name a été ajouté avec succès",
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

  Future<Object> edit(
      {required BuildContext context, name, location, description}) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String q = '''
        UPDATE warehouse SET 
        name = "$name", location = "$location", description = "$description", modified_date = NOW()
        WHERE id = ${_warehouseList[_selected].id} AND NOT(
          name = "$name" AND location = "$location" AND description = "$description"
        );
        ''';
      final result = await conn.query(q);
      conn.close();
      if (result.affectedRows! > 0) {
        setList(context: context);
        context.read<NotificationProvider>().showNotification(
              message: "L'entrepôt $name a été modifié avec succès.",
              type: 0,
            );
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

  Future<Object> delete({
    required BuildContext context,
  }) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String q = '''
        SELECT * FROM product WHERE warehouse = ${_warehouseList[_selected].id};
        ''';
      var result = await conn.query(q);
      if (result.isNotEmpty) {
        context.read<NotificationProvider>().showNotification(
              message:
                  "L'entrepôt ${_warehouseList[_selected].name} ne peut pas être supprimée (utilisée dans les produits)",
              type: 1,
            );
        return false;
      }
      q = '''
        DELETE FROM warehouse WHERE id = ${_warehouseList[_selected].id};
        ''';
      result = await conn.query(q);
      conn.close();
      if (result.affectedRows! >= 0) {
        setList(context: context);
        context.read<NotificationProvider>().showNotification(
              message:
                  "L'entrepôt ${_warehouseList[_selected].name} a été supprimé",
              type: 0,
            );
        return true;
      }
      context.read<NotificationProvider>().showNotification(
            message:
                "L'entrepôt ${_warehouseList[_selected].name} ne peut pas être supprimé",
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
