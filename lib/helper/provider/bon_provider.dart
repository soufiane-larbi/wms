import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/helper/config.dart';

class BonProvider with ChangeNotifier {
  final _bonList = [], _tempBonList = [];
  int _selected = 0, _underWarranty = 0;
  String? _beneficiary, _ticket;
  double _totalPrice = 0;

  int get selected => _selected;
  get bonList => _bonList;
  get temBonList => _tempBonList;
  get beneficiary => _beneficiary;
  get ticket => _ticket;
  get totalPrice => _totalPrice;
  get underWarranty => _underWarranty;

  set beneficiary(b) {
    _beneficiary = b;
  }

  set ticket(t) {
    _ticket = t;
  }

  void changeSelected(index) {
    _selected = index;
    notifyListeners();
  }

  Future<void> setBonList({filter = ''}) async {
    _bonList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    _bonList.addAll(
        await conn.query("SELECT * FROM bon  $filter ORDER BY date DESC;"));
    notifyListeners();
    conn.close();
  }

  Future<int> addBon(
      {required history,
      required user,
      required ticket,
      required beneficiary,
      reset = true}) async {
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    var result = await conn.query(
      '''INSERT INTO bon (history,user,total,beneficiary, ticket, date)
      VALUES('$history',
      '$user',
      $_totalPrice,
      '$beneficiary',
      '$ticket',
      NOW()
      );''',
    );
    if (reset) {
      _beneficiary = '';
      _ticket = '';
      _tempBonList.clear();
      _underWarranty = 0;
      _totalPrice = 0;
    }
    setBonList();
    notifyListeners();
    return result.insertId!;
  }

  manualReset() {
    _beneficiary = '';
    _ticket = '';
    _tempBonList.clear();
    _underWarranty = 0;
    _totalPrice = 0;
    notifyListeners();
    setBonList();
  }

  addTempBon({required pdrId, required price, required quantity}) {
    _tempBonList.add({
      'pdrId': pdrId,
      'price': price,
      'quantity': quantity,
      'beneficiary': _beneficiary,
      'ticket': ticket,
    });
    price == 0 ? _underWarranty++ : _totalPrice += price * quantity;
    if (_tempBonList.isEmpty) {
      price = 0;
      _beneficiary = null;
      _ticket = null;
    }
    notifyListeners();
    return 0;
  }

  removeItemFromTempBon(index) {
    _tempBonList[index]['price'] == 0
        ? _underWarranty--
        : _totalPrice -=
            _tempBonList[index]['price'] * _tempBonList[index]['quantity'];
    _tempBonList.removeAt(index);
    notifyListeners();
  }

  Future<void> query({query = '', filter = ''}) async {
    _bonList.clear();
    var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
    await conn.query(query);
    _bonList.addAll(await conn.query("select * from bon " + filter));
    notifyListeners();
    conn.close();
  }
}
