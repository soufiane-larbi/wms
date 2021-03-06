import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/helper/provider/zone_provider.dart';
import 'package:whm/layout/category.dart';
import 'package:whm/layout/side_menu.dart';
import 'helper/provider/user_provider.dart';
import 'layout/login.dart';
import 'layout/stock.dart';
import 'package:mysql1/mysql1.dart';
import 'layout/zone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ZoneProvider()),
        ChangeNotifierProvider(create: (_) => LayoutProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: const MaterialApp(
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
  final List<Widget> _screens = [
    const Stock(),
    const CategoryScreen(),
    const ZoneScreen(),
  ];
  @override
  void initState() {
    try {
      context.read<StockProvider>().setStockList();
      context.read<HistoryProvider>().setHistoryList();
      context.read<CategoryProvider>().setCategoryList();
      context.read<ZoneProvider>().setZoneList();
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
      body: !context.watch<UserProvider>().connected
          ? Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/background2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Login(),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 200,
                  margin: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: const SideMenu(),
                ),
                Expanded(
                  child: _screens[context.watch<LayoutProvider>().screenIndex],
                ),
              ],
            ),
    );
  }
}
