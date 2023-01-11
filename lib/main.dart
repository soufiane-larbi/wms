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
import 'layout/bon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      body: FutureBuilder(
        future: AppConfig.initDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false) return showConnectionError();
            if (snapshot.data == true &&
                context.watch<UserProvider>().connected) return showInterface();
            return showLogin();
          }
          return connecting();
        },
      ),
    );
  }

  Widget connecting() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Connexion à la base de données'),
          SizedBox(width: 7),
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget showConnectionError() {
    return Container(
      alignment: Alignment.center,
      child: Text(AppConfig.DB_ERROR),
    );
  }

  Widget showLogin() {
    return Stack(
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
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Login(),
        ),
      ],
    );
  }

  Widget showInterface() {
    return Row(
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
    );
  }
}
