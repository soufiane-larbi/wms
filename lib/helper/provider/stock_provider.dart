import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/layout/app_bar.dart';

class StockProvider with ChangeNotifier {
  final _stockList = [],
      _returnList = [],
      _outOfStock = [],
      _lowStock = [],
      _retourned = [],
      _waiting = [],
      _late = [],
      _stats = {
        'Stock Faible': 0.0,
        'Rupture De Stock': 0.0,
        'PDRs': 0.0,
      },
      _statsWarranty = {
        'Retourné': 0.0,
        'En Attendant': 0.0,
        'En Retard': 0.0,
      };
  int _selected = 0, _returnSelected = 0;

  int get selected => _selected;
  int get returnSelected => _returnSelected;
  get stockList => _stockList;
  get returnList => _returnList;
  get stats => _stats;
  get warrantyStats => _statsWarranty;

  Future<int> updatePDR({id, newId, quantity, price, name, product}) async {
    try {
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      String query = '''UPDATE pdr SET 
      id = '$newId',
      name = '$name',
      product = '$product',
      quantity = $quantity,
      price = $price,
      modified_date = NOW()
      WHERE id = '$id';
      ''';
      var result = await conn.query(
        query,
      );
      conn.close();
      _selected = 0;
      setStockList(
        filter: '''
                    WHERE (id LIKE '%${StockToolBar.editingController.text}%'
                    OR name LIKE '%${StockToolBar.editingController.text}%'
                    OR product LIKE '%${StockToolBar.editingController.text}%') 
                  ''',
      );
      return result.affectedRows!;
    } catch (_) {
      return 0;
    }
  }

  void changeReturnSelected(index) {
    _returnSelected = index;
    notifyListeners();
  }

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> reset({filter = ''}) async {
    _selected = 0;
    _returnSelected = 0;
    setStockList();
    setReturnList();
    notifyListeners();
  }

  Future<void> setStockList({filter = ''}) async {
    _stockList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    _stockList.addAll(await conn.query('''
      SELECT * FROM pdr
      ${filter == '' ? 'WHERE' : '$filter AND'}
      quantity > 0 
      ORDER BY modified_date DESC;
    '''));
    setStats();

    if (_selected >= _stockList.length) {
      _selected = _stockList.length - 1;
    }
    notifyListeners();
    conn.close();
  }

  Future<void> setReturnList({filter = ''}) async {
    _returnList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    _returnList.addAll(await conn.query('''
      SELECT pdr.name, pdr.product, pdr.id as pdr, 
      returnPdr.ticket, returnPdr.beneficiary, returnPdr.status,
      returnPdr.price, returnPdr.quantity, returnPdr.date, returnPdr.id
      FROM returnPdr
      INNER JOIN pdr on pdr.id = returnPdr.pdr 
      ${filter == '' ? 'WHERE' : '$filter AND'}
      status < 2 
      ORDER BY date DESC;
    '''));
    notifyListeners();
    conn.close();
  }

  Future<bool> addReturn(
      {required pdr,
      required quantity,
      required beneficiary,
      required ticket,
      required price,
      required bon}) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query(
      '''INSERT INTO returnPdr(
        pdr, quantity, ticket, beneficiary, price, bon,status, date
      )
      VALUES (
        '$pdr', $quantity, '$ticket', '$beneficiary', $price, $bon, 0, NOW()
      );
      ''',
    );
    if (result.affectedRows == 0) return false;
    setReturnList();
    conn.close();
    return true;
  }

  Future<bool> addStock({id, name, quantity, product, price, user}) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query(
      '''INSERT IGNORE INTO pdr(
        id, name, quantity, product, price, creation_date, modified_date
      )
      VALUES (
        '$id', '$name', $quantity, '$product', $price, NOW(), NOW()
      );
      ''',
    );
    if (result.affectedRows == 0) return false;
    setStockList();
    conn.close();
    return true;
  }

  Future<bool> updateStockQuantity({
    required newQuantity,
    required pdrId,
  }) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query(
      "UPDATE pdr SET quantity = $newQuantity WHERE id = '$pdrId';",
    );
    if (result.affectedRows == 0) return false;
    setStockList();
    conn.close();
    return true;
  }

  Future<bool> updateReturnStatus({
    required status,
    required returnId,
  }) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query(
      "UPDATE returnPdr SET status = $status, date = NOW()  WHERE id = '$returnId';",
    );
    if (result.affectedRows == 0) return false;
    setReturnList();
    conn.close();
    return true;
  }

  Future<int> getQuantity({pdr}) async {
    var result = [];
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    result.addAll(
      await conn.query(
        "SELECT quantity FROM pdr WHERE id = '$pdr';",
      ),
    );
    return result.first['quantity'];
  }

  Future<double> getPrice({pdr}) async {
    var result = [];
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    result.addAll(
      await conn.query(
        "SELECT price FROM pdr WHERE id = '$pdr';",
      ),
    );
    return result.first['price'];
  }

  Future<void> query({query = ''}) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    await conn.query(query);
    setStockList();
    conn.close();
  }

  Future<void> setStats() async {
    _lowStock.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    _lowStock.addAll(
      await conn.query('''
      SELECT * FROM pdr
      WHERE quantity < 10 AND quantity > 0;
    '''),
    );
    _stats['Stock Faible'] = _lowStock.length * 1.0;
    _outOfStock.clear();
    _outOfStock.addAll(
      await conn.query('''
      SELECT * FROM pdr
      WHERE quantity = 0;
    '''),
    );
    _stats['Rupture De Stock'] = _outOfStock.length * 1.0;
    _stats['PDRs'] = _stockList.length * 1.0 - _lowStock.length * 1.0;

    _retourned.clear();
    _retourned.addAll(
      await conn.query('''
      SELECT * FROM returnPdr WHERE status = 1;
    '''),
    );
    _waiting.clear();
    _waiting.addAll(
      await conn.query('''
      SELECT * FROM returnPdr WHERE status = 0;
    '''),
    );
    _late.clear();
    _late.addAll(
      await conn.query('''
      SELECT * FROM returnPdr WHERE status = 0 AND DATEDIFF(NOW(), date ) > 15;
    '''),
    );
    _statsWarranty['Retourné'] = _retourned.length * 1.0;
    _statsWarranty['En Attendant'] = _waiting.length * 1.0 - _late.length * 1.0;
    _statsWarranty['En Retard'] = _late.length * 1.0;
    notifyListeners();
    conn.close();
  }
}
