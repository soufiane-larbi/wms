import 'dart:async';
import 'provider/stock_provider.dart';
import 'package:mysql1/mysql1.dart';

class AppConfig {
  // ignore: non_constant_identifier_names
  ConnectionSettings DB_CONNECTION = ConnectionSettings(
    host: '192.168.1.242',
    port: 3306,
    user: 'sav_user',
    db: 'sav_user',
    password: 'Raylan@22',
  );

  autoRefresh({run = true}) {
    if (!run) return;
    Timer.periodic(const Duration(seconds: 15), (timer) {
      StockProvider stock = StockProvider();
      stock.setStockList();
    });
  }
}
