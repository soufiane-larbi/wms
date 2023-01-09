import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/helper/provider/bon_provider.dart';
import 'package:whm/layout/dashbord.dart';
import 'package:whm/layout/history.dart';
import 'package:whm/layout/return.dart';
import 'package:whm/layout/side_menu.dart';
import 'helper/provider/user_provider.dart';
import 'layout/login.dart';
import 'layout/stock.dart';
import 'package:mysql1/mysql1.dart';
import 'layout/bon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => BonProvider()),
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
    const ReturnScreen(),
    const BonScreen(),
    const History(),
    const Dashboard(),
  ];
  @override
  void initState() {
    try {
      context.read<StockProvider>().setStockList();
      context.read<HistoryProvider>().setHistoryList();
      context.read<StockProvider>().setReturnList();
      context.read<BonProvider>().setBonList();
      //AppConfig().autoRefresh(run: true);
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
