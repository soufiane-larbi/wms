import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/helper/config.dart';

class UserProvider with ChangeNotifier {
  bool _connected = false;
  String? _user, _role, _name;

  get user => _user;
  get name => _name;
  get role => _role;
  get connected => _connected;

  Future<bool> auth({required user, required password}) async {
    try {
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      var _userList = [];
      _userList.addAll(await conn.query(
          "select * from users where user like '$user' and password = '$password'"));
      conn.close();
      if (_userList.isNotEmpty) {
        _user = _userList[0]['user'];
        _name = "${_userList[0]['name']} ${_userList[0]['prename']}";
        _role = _userList[0]['role'];
        _connected = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
