import 'dart:async';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/category_type.dart';
import 'package:whm/Formater/product_type.dart';
import 'package:whm/Formater/warehouse_type.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/notification_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductType> _productList = [];
  final List<ProductType> _removeList = [];
  int _selected = 0;
  int get selected => _selected;
  get productList => _productList;
  get removeList => _removeList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  void addRemove(ProductType product) {
    _removeList.add(product);
    notifyListeners();
  }

  Future<void> reset({required BuildContext context, filter = ''}) async {
    _selected = 0;
    setList(context: context);
  }

  Future<Object> setList(
      {required BuildContext context, String filter = ''}) async {
    try {
      _productList.clear();
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      final result = await conn.query('''
  SELECT product.id, product.name, product.quantity, product.barcode, product.image, product.unit,
  product.creation_date, product.modified_date,
  warehouse.name as warehouseName, 
  category.name as categoryName, category.creation_date as categoryCD,category.modified_date as categoryMD,
  category.image as categoryIM,
  product.category, product.warehouse
  FROM `product` 
  INNER JOIN warehouse ON warehouse.id = product.warehouse
  INNER JOIN category ON category.id = product.category
  WHERE product.name like '%$filter%' OR category.name LIKE '%$filter%' OR warehouse.name LIKE '%$filter%'
  AND  product.quantity > 0 
  ORDER BY product.creation_date DESC;
  ''');
      conn.close();
      for (final row in result) {
        final product = ProductType(
          id: row['id'],
          name: row['name'],
          unit: row['unit'],
          barcode: row['barcode'],
          category: CategoryType(
            id: row['category'],
            name: row['categoryName'],
            image: row['categoryIM'],
            creationDate: row['categoryCD'],
            modifiedDate: row['categoryMD'],
          ),
          warehouse:
              WarehouseType(id: row['warehouse'], name: row['warehouseName']),
          image: row['image'],
          creationDate: row['creation_date'],
          modifiedDate: row['modified_date'],
          quantity: row['quantity'],
        );
        _productList.add(product);
      }
      if (_selected > _productList.length - 1) {
        _selected = _productList.length - 1;
      }
      if (_selected == -1 && _productList.isNotEmpty) {
        _selected = 0;
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

  Future<Object> add({
    required BuildContext context,
    ProductType? product,
  }) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String imageHex = product!.image != null
          ? "0x${hex.encode(product.image!.toBytes())}"
          : "null";
      String q = '''
        INSERT INTO `product` (`name`, `quantity`, `unit`, `barcode`, `image`, `category`, `warehouse`) 
        VALUES (
          "${product.name}", ${product.quantity}, "${product.unit}",
          "${product.barcode}", $imageHex, ${product.category!.id}, ${product.warehouse!.id}
        );
        ''';
      final result = await conn.query(q);
      conn.close();
      setList(context: context);
      if (result.insertId! >= 0) {
        context.read<NotificationProvider>().showNotification(
              message: "le produit ${product.name} a été ajouté avec succès.",
              type: 0,
            );
        context.read<HistoryProvider>().add(
              user: context.read<UserProvider>().user.first.username,
              productNew: product,
            );
        return true;
      }
      context.read<NotificationProvider>().showNotification(
            message: "le produit ${product.name} a été ajouté avec succès.",
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

  Future<Object> edit({
    required BuildContext context,
    required ProductType? productNew,
    ProductType? productOld,
  }) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String imageHex = productNew!.image != null
          ? "0x${hex.encode(productNew.image!.toBytes())}"
          : productOld!.image != null
              ? "0x${hex.encode(productOld.image!.toBytes())}"
              : "NULL";
      String q = '''
        UPDATE product SET name = "${productNew.name}", barcode = "${productNew.barcode}", quantity = ${productNew.quantity},
        unit = "${productNew.unit}", image = $imageHex, category = ${productNew.category!.id}, warehouse = ${productNew.warehouse!.id}
        WHERE id = ${_productList[_selected].id}
        ''';
      String qNext = '''
        UPDATE product SET modified_date = NOW()
        WHERE id = ${_productList[_selected].id}
        ''';
      var result = await conn.query(q);

      if (result.affectedRows! > 0) {
        result = await conn.query(qNext);
        context.read<NotificationProvider>().showNotification(
              message:
                  "le produit ${productNew.name} a été modifié avec succès.",
              type: 0,
            );
        context.read<HistoryProvider>().add(
              user: context.read<UserProvider>().user.first.username,
              productNew: productNew,
              productOld: productOld,
            );
        setList(context: context);
        conn.close();
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
        DELETE FROM product WHERE id = ${_productList[_selected].id};
        ''';
      final result = await conn.query(q);
      conn.close();

      if (result.affectedRows! != 0) {
        context.read<NotificationProvider>().showNotification(
              message:
                  "le produit ${_productList[_selected].name} a été supprimé avec succès.",
              type: 0,
            );
        setList(context: context);
        return true;
      }
      context.read<NotificationProvider>().showNotification(
            message:
                "Le produit ${_productList[_selected].name} n'a pas pu être supprimé!",
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

  Future<Object> remove({required BuildContext context}) async {
    try {
      final conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      for (ProductType product in _removeList) {
        String q = '''
        UPDATE product SET quantity = (quantity-${product.remove}) WHERE id = ${product.id};
        ''';
        await conn.query(q);
      }
      conn.close();
      _removeList.clear();
      setList(context: context);
      return true;
    } on Exception catch (e) {
      context.read<NotificationProvider>().showNotification(
            message: e,
            type: 2,
          );
      return e;
    }
  }

  removeFromRemoveList(index) {
    _removeList[index].remove = 0;
    _removeList.removeAt(index);
    notifyListeners();
  }
}
