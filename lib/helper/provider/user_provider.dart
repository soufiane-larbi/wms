import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class UserProvider with ChangeNotifier {
  final _userList = [];
  bool _connected = false;

  get userList => _userList;
  get connected => _connected;
  setConnected(connected) {
    _connected = connected;
    notifyListeners();
  }

  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    db: 'stock',
  );

  Future<void> setUserList({query = ''}) async {
    _userList.clear();
    var conn = await MySqlConnection.connect(settings);
    _userList.addAll(await conn.query("select * from users " + query));
    notifyListeners();
    conn.close();
  }
}
