import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/layout/app_bar.dart';
import 'layout/stock.dart';
import 'package:mysql1/mysql1.dart';

void main() async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
  );
  var conn = await MySqlConnection.connect(settings);
  await conn.query("CREATE DATABASE IF NOT EXISTS STOCK");
  await conn.query(
    '''CREATE TABLE IF NOT EXISTS `stock`.`zone` (
      `id` INT NOT NULL AUTO_INCREMENT ,
      `name` VARCHAR(50) NOT NULL ,
      `address` VARCHAR(250) NOT NULL ,
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`)) ENGINE = MyISAM;
    ''',
  );
  await conn.query(
    '''CREATE TABLE IF NOT EXISTS `stock`.`category` (
      `id` INT NOT NULL AUTO_INCREMENT ,
      `name` VARCHAR(100) NOT NULL ,
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`)) ENGINE = MyISAM;
    ''',
  );
  await conn.query(
    '''CREATE TABLE IF NOT EXISTS `stock`.`products` ( 
      `id` INT NOT NULL AUTO_INCREMENT ,
      `name` VARCHAR(50) NOT NULL ,
      `model` VARCHAR(30) NOT NULL ,
      `category` INT NOT NULL ,
      `sku` VARCHAR(30) NULL ,
      `quantity` INT NOT NULL ,
      `remain` INT NOT NULL ,
      `zone` INT NOT NULL ,
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
      PRIMARY KEY (`id`),
      FOREIGN KEY (`zone`) REFERENCES `stock`.`zone`(`id`),
      FOREIGN KEY (`category`) REFERENCES `stock`.`category`(`id`)) ENGINE = MyISAM;
    ''',
  );
  await conn.query(
    '''CREATE TABLE IF NOT EXISTS `stock`.`users` ( 
      `id` INT NOT NULL AUTO_INCREMENT , 
      `user` VARCHAR(50) NOT NULL ,
      `password` VARCHAR(20) NOT NULL ,
      `name` VARCHAR(35) NOT NULL ,
      `prename` VARCHAR(35) NOT NULL , 
      `creation_date` TIMESTAMP NOT NULL ,
      `modified_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`id`)) ENGINE = MyISAM;
    ''',
  );
  await conn.query(
    '''CREATE TABLE IF NOT EXISTS `stock`.`history` ( 
      `id` INT NOT NULL AUTO_INCREMENT , 
      `user` INT NULL , 
      `product` INT NOT NULL , 
      `operation` INT NOT NULL , 
      `previous_quantity` INT NOT NULL , 
      `new_quantity` INT NOT NULL , 
      `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
      PRIMARY KEY (`id`),
      FOREIGN KEY (`product`) REFERENCES `stock`.`products`(`id`)) ENGINE = MyISAM;
    ''',
  );
  conn.close();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        home: Home(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    try {
      context.read<StockProvider>().setStockList();
      context.read<HistoryProvider>().setHistoryList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.only(
              top: 8,
              right: 8,
              left: 8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: const StockToolBar(),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(
              top: 8,
              right: 8,
              left: 8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: stockHeader(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                right: 8,
                left: 8,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: const Stock(),
            ),
          ),
        ],
      ),
    );
  }

  Widget stockHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 13,
          child: Text('Nom'),
        ),
        Expanded(
          flex: 13,
          child: Text('Model'),
        ),
        Expanded(
          flex: 13,
          child: Text('Categorie'),
        ),
        Expanded(
          flex: 7,
          child: Text('SKU'),
        ),
        Expanded(
          flex: 7,
          child: Text('Quantity'),
        ),
        Expanded(
          flex: 7,
          child: Text('Restant'),
        ),
        Expanded(
          flex: 7,
          child: Text('Location'),
        ),
        Expanded(
          flex: 9,
          child: Text('Date De Creation'),
        ),
        Expanded(
          flex: 9,
          child: Text('Dernier Modification'),
        ),
      ],
    );
  }
}
