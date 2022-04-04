import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class StockProvider with ChangeNotifier {
  final _stockList = [];
  int _selected = 0;

  int get selected => _selected;
  get stockList => _stockList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> setStockList({query = ''}) async {
    _stockList.clear();
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase("database.sqlite3");
    query == '' ? _stockList.addAll(await db.rawQuery("select * from stock where quantity > 0 order by type asc")) : _stockList.addAll(await db.rawQuery(query));
    notifyListeners();
  }

  Future<void> setDB({query = ''}) async {
    _stockList.clear();
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase("database.sqlite3");
    await db.execute(query);
    _stockList.addAll(await db.rawQuery("select * from stock where quantity > 0 order by type asc"));
    notifyListeners();
  }
}
