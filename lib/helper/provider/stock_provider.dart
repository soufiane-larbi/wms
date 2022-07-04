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

  Future<void> setStockList({query = ''}) async {
    _stockList.clear();
    var conn = await MySqlConnection.connect(settings);
    _stockList.addAll(await conn
        .query("select * from products where remain > 0 order by id desc"));
    notifyListeners();
    conn.close();
  }

  Future<void> query({query = ''}) async {
    _stockList.clear();
    var conn = await MySqlConnection.connect(settings);
    _stockList.addAll(await conn.query(query));
    notifyListeners();
    conn.close();
  }
}
