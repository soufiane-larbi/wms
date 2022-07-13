import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class ZoneProvider with ChangeNotifier {
  final _categoryList = [];
  int _selected = 0;

  int get selected => _selected;
  get categoryList => _categoryList;
  get stockList => _categoryList;
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

  Future<void> setZoneList({query = ''}) async {
    _categoryList.clear();
    var conn = await MySqlConnection.connect(settings);
    _categoryList.addAll(await conn.query("select * from zone" + query));
    notifyListeners();
    conn.close();
  }

  Future<void> query({query = '', filter = ''}) async {
    _categoryList.clear();
    var conn = await MySqlConnection.connect(settings);
    await conn.query(query);
    _categoryList.addAll(await conn.query("select * from zone " + filter));
    notifyListeners();
    conn.close();
  }
}
