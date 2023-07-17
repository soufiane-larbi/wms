import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:whm/helper/config.dart';
import '../../Formater/user_type.dart';

class UserProvider with ChangeNotifier {
  final List<UserType> _user = [];
  get user => _user;

  Future<Object> auth({required user, required password}) async {
    try {
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      final result = await conn.query(
          "select * from users where username like '$user' and password = '$password'");
      conn.close();
      if (result.isEmpty) {
        return false;
      }
      for (final row in result) {
        final user = UserType(
          firstname: row['firstname'],
          lastname: row['lastname'],
          profile: row['profile'],
          username: row['username'],
          password: row['password'],
          admin: true,
          creationDate: row['creation_date'],
          modifiedDate: row['modified_date'],
        );
        _user.add(user);
      }
      notifyListeners();
      return true;
    } catch (e) {
      return e;
    }
  }

  reset() {
    _user.clear();
    notifyListeners();
  }
}
