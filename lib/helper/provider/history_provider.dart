import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HistoryProvider with ChangeNotifier {
  final _historyList = [];

  get historyList => _historyList;

  Future<void> setHistoryList() async {
    _historyList.clear();
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase("database.sqlite3");
    _historyList.addAll(await db.query('history', orderBy: 'id desc'));
    notifyListeners();
  }

  Future<void> setDB({query = ''}) async {
    _historyList.clear();
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase("database.sqlite3");
    await db.execute(query);
    _historyList.addAll(await db.query("history", orderBy: 'id desc'));
    notifyListeners();
  }
}
