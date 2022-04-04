import 'package:sqflite_common_ffi/sqflite_ffi.dart';


Future initDatabase() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  return await databaseFactory.openDatabase("database.sqlite3");
}
