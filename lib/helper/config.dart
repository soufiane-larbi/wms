import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/product_provider.dart';
import 'package:mysql1/mysql1.dart';

class AppConfig {
  static SharedPreferences? preferences;
  static String? ip, user, password;
  static int? port;
  // ignore: non_constant_identifier_names
  ConnectionSettings DB_CONNECTION = ConnectionSettings(
    host: ip ?? '105.96.32.133',
    port: port ?? 3306,
    user: user ?? 'raylan',
    db: 'whm',
    password: password ?? 'Raylan@23',
  );
  // ignore: non_constant_identifier_names
  static bool? DB_IS_CONNECTED;
  // ignore: non_constant_identifier_names
  static String DB_ERROR = '';
  static bool pauseAutoRefresh = false;
  static bool isAdmin = false;

  static Future<bool> initDatabase() async {
    try {
      var conn = await MySqlConnection.connect(AppConfig().DB_CONNECTION);
      await conn.query("CREATE DATABASE IF NOT EXISTS whm;");
      await conn.query("use whm;");
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `whm`.`users` ( 
      `username` VARCHAR(64) NOT NULL ,
      `password` VARCHAR(64) NOT NULL,
      `firstname` VARCHAR(64) NOT NULL ,
      `profile` MEDIUMBLOB ,
      `lastname` VARCHAR(256) NOT NULL DEFAULT '',
      `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`username`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `whm`.`warehouse` ( 
      `id` INT NOT NULL AUTO_INCREMENT  ,
      `name` VARCHAR(64) NOT NULL ,
      `location` VARCHAR(256) NOT NULL DEFAULT '',
      `description` VARCHAR(512) NOT NULL DEFAULT '',
      `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `whm`.`category` ( 
      `id` INT NOT NULL AUTO_INCREMENT ,
      `name` VARCHAR(256) NOT NULL ,
      `image` MEDIUMBLOB,
      `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `whm`.`product` ( 
      `id` INT NOT NULL AUTO_INCREMENT,
      `name` VARCHAR(64) NOT NULL,
      `quantity` FLOAT NOT NULL DEFAULT 0.0,
      `unit` VARCHAR(8) NOT NULL DEFAULT 'M',
      `barcode` VARCHAR(64) NOT NULL DEFAULT '',
      `image` MEDIUMBLOB ,
      `inventory` VARCHAR(8) NOT NULL DEFAULT '',
      `price` FLOAT NOT NULL DEFAULT 0.0,
      `category` INT NOT NULL ,
      `warehouse` INT NOT NULL ,
      `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`),
      FOREIGN KEY (`category`) REFERENCES `whm`.`category`(`id`),
      FOREIGN KEY (`warehouse`) REFERENCES `whm`.`warehouse`(`id`)
      ) ENGINE = MyISAM;
    ''',
      );
      await conn.query(
        '''CREATE TABLE IF NOT EXISTS `whm`.`history` ( 
      `id` INT NOT NULL AUTO_INCREMENT , 
      `user` INT NOT NULL , 
      `product_old` VARCHAR(2048) NOT NULL ,
      `product_new` VARCHAR(2048) NOT NULL ,
      `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`id`),
      FOREIGN KEY (`user`) REFERENCES `whm`.`user`(`id`)
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
    // if (!run) return;
    // Timer.periodic(const Duration(seconds: 15), (timer) {
    //   ProductProvider stock = ProductProvider();
    //   stock.setList();
    // });
  }
}
