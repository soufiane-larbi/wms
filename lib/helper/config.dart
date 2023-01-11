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

  // ignore: non_constant_identifier_names
  static bool? DB_IS_CONNECTED;
  // ignore: non_constant_identifier_names
  static String DB_ERROR = '';
  static bool pauseAutoRefresh = false;
  static bool isAdmin = false;
  static String user = '-', username = '-';

  static Future<bool> initDatabase() async {
    try {
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      await conn.query("CREATE DATABASE IF NOT EXISTS sav_user");
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `sav_user`.`pdr` ( 
      `id` VARCHAR(64) NOT NULL ,
      `name` VARCHAR(64) NOT NULL ,
      `product` VARCHAR(64) NOT NULL ,
      `quantity` INT NOT NULL ,
      `price` FLOAT NOT NULL DEFAULT 0.0,
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `sav_user`.`returnPdr` ( 
      `id` int NOT NULL AUTO_INCREMENT ,
      `pdr` VARCHAR(64) NOT NULL ,
      `bon` INT NOT NULL ,
      `ticket` VARCHAR(64) NOT NULL ,
      `beneficiary` VARCHAR(64) NOT NULL ,
      `quantity` INT NOT NULL ,
      `price` FLOAT NOT NULL DEFAULT 0.0,
      `status` INT NOT NULL DEFAULT 0,
      `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`),
      FOREIGN KEY (`pdr`) REFERENCES `sav`.`pdr`(`id`),
      FOREIGN KEY (`bon`) REFERENCES `sav`.`bon`(`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `sav_user`.`users` ( 
      `user` VARCHAR(64) NOT NULL ,
      `password` VARCHAR(64) NOT NULL ,
      `name` VARCHAR(64) NOT NULL ,
      `prename` VARCHAR(64) NOT NULL , 
      `role` VARCHAR(64) NOT NULL , 
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`user`)) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `sav_user`.`history` ( 
      `id` INT NOT NULL AUTO_INCREMENT , 
      `user` VARCHAR(64) NOT NULL , 
      `ticket` VARCHAR(64) NOT NULL ,
      `beneficiary` VARCHAR(128) NOT NULL ,
      `pdr` VARCHAR(64) NOT NULL ,
      `price` VARCHAR(64) NOT NULL DEFAULT '0.0',
      `operation` VARCHAR(10) NOT NULL , 
      `previous_quantity` INT NOT NULL , 
      `new_quantity` INT NOT NULL , 
      `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`id`),
      FOREIGN KEY (`pdr`) REFERENCES `sav`.`pdr`(`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `sav_user`.`bon` ( 
      `id` INT NOT NULL AUTO_INCREMENT , 
      `history` VARCHAR(1024) NOT NULL , 
      `user` VARCHAR(64) NOT NULL ,
      `beneficiary` VARCHAR(64) NOT NULL ,
      `ticket` VARCHAR(64) NOT NULL ,
      `total` double NOT NULL ,
      `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      conn.close();
      return true;
    } on Exception catch (e) {
      DB_IS_CONNECTED = false;
      DB_ERROR = e.toString();
      return false;
    }
  }

  autoRefresh({run = true}) {
    if (!run) return;
    Timer.periodic(const Duration(seconds: 15), (timer) {
      StockProvider stock = StockProvider();
      stock.setStockList();
    });
  }
}
