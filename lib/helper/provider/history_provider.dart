import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/Formater/history_type.dart';
import 'package:whm/Formater/product_type.dart';
import 'package:whm/helper/config.dart';

class HistoryProvider with ChangeNotifier {
  final List<HistoryType> _historyList = [];
  int _selected = 0;

  int get selected => _selected;
  get historyList => _historyList;
  get stockList => _historyList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> setList({filter = ''}) async {
    _historyList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query('''
      SELECT * from history ORDER BY date DESC;
    ''');

    for (var row in result) {
      _historyList.add(HistoryType(
        id: row['id'],
        user: row['user'],
        date: row['date'],
        productNew: ProductType.fromJson(jsonDecode(row['product_new'])),
        productOld: jsonDecode(row['product_old']).isEmpty
            ? ProductType()
            : ProductType.fromJson(jsonDecode(row['product_old'])),
      ));
    }
    notifyListeners();
    conn.close();
  }

  Future<bool> add({
    required String user,
    required ProductType productNew,
    ProductType? productOld,
  }) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var pOld = productOld ?? {};
    String q = '''INSERT INTO history(user, product_new, product_old, date)
        VALUES("$user", '${jsonEncode(productNew)}', '${jsonEncode(pOld)}', NOW());
      ''';
    await conn.query(q);
    setList();
    notifyListeners();
    return true;
  }
}
