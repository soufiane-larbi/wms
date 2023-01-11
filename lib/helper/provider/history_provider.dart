import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/helper/config.dart';

class HistoryProvider with ChangeNotifier {
  final _historyList = [];
  int _selected = 0;

  int get selected => _selected;
  get historyList => _historyList;
  get stockList => _historyList;

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> setHistoryList({filter = ''}) async {
    _historyList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    _historyList.addAll(await conn.query('''SELECT 
        pdr.id, pdr.name, history.user, history.ticket, history.beneficiary, 
        history.price, history.operation, history.previous_quantity,
        history.new_quantity, history.date 
        FROM history 
        INNER JOIN pdr 
        ON pdr.id = history.pdr
        $filter ORDER BY history.date DESC;'''));
    notifyListeners();
    conn.close();
  }

  Future<bool> addHistory({
    required String? user,
    String ticket = '-',
    String beneficiary = '-',
    required String? pdr,
    required String? operation,
    int previousQuantity = 0,
    required int? newQuantity,
    double? price = 0,
  }) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    await conn.query(
      '''INSERT INTO history(
          user, ticket, beneficiary, pdr , price, operation,
          previous_quantity, new_quantity, date
        )
        VALUES('$user', '$ticket', '$beneficiary', '$pdr', $price, '$operation',
          $previousQuantity, $newQuantity,  NOW()
        );
        ''',
    );
    setHistoryList();
    notifyListeners();
    return true;
  }

  Future<void> query({query = ''}) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    await conn.query(query);
    setHistoryList();
    notifyListeners();
    conn.close();
  }
}
