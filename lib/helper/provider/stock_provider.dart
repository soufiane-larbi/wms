import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class StockProvider with ChangeNotifier {
  final _stockList = [];
  int _selected = 0;

  int get selected => _selected;
  get stockList => _stockList;
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    db: 'stock',
  );

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> setStockList({filter = ''}) async {
    _stockList.clear();
    var conn = await MySqlConnection.connect(settings);
    _stockList.addAll(await conn.query('''
      SELECT products.*, category.name as catName, zone.name as zoneName 
      FROM products 
      INNER join category on products.category = category.id 
      inner join zone on products.zone = zone.id
      $filter order by id desc
    '''));
    notifyListeners();
    conn.close();
  }

  Future<void> query({query = '', filter = ''}) async {
    _stockList.clear();
    var conn = await MySqlConnection.connect(settings);
    await conn.query(query);
    _stockList.addAll(await conn.query('''
      SELECT products.*, category.name as catName, zone.name as zoneName 
      FROM products 
      INNER join category on products.category = category.id 
      inner join zone on products.zone = zone.id $filter
    '''));
    notifyListeners();
    conn.close();
  }
}
