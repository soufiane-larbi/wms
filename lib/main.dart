import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/helper/print.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/notification_provider.dart';
import 'package:whm/helper/provider/product_provider.dart';
import 'package:whm/helper/provider/warehouse_provider.dart';
import 'package:whm/layout/dashbord.dart';
import 'package:whm/layout/category.dart';
import 'package:whm/layout/history.dart';
import 'package:whm/layout/side_menu.dart';
import 'helper/provider/user_provider.dart';
import 'layout/login.dart';
import 'layout/product.dart';
import 'layout/warehouse.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  AppConfig.preferences = await SharedPreferences.getInstance();
  AppConfig.ip = AppConfig.preferences!.getString('ip');
  AppConfig.port = AppConfig.preferences!.getInt('port');
  AppConfig.user = AppConfig.preferences!.getString('user');
  AppConfig.password = AppConfig.preferences!.getString('password');

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => WarehouseProvider()),
        ChangeNotifierProvider(create: (_) => LayoutProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
  final TextEditingController _host = TextEditingController();
  final TextEditingController _port = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final List<Widget> _screens = [
    const Product(),
    const CategoryS(),
    const Warehouse(),
    const History(),
    const Dashboard(),
  ];
  int _isDbconnected = -1;
  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          (context.watch<UserProvider>().user.isNotEmpty && _isDbconnected == 1)
              ? showInterface()
              : _isDbconnected == -1
                  ? connecting()
                  : _isDbconnected == 1
                      ? showLogin()
                      : showConnectionError(),
          Align(
            alignment: Alignment.bottomRight,
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              color: Colors.transparent,
              padding: const EdgeInsets.all(10),
              height: 100,
              width:
                  context.read<NotificationProvider>().notificationList.isEmpty
                      ? 0
                      : 370,
              child: context
                      .watch<NotificationProvider>()
                      .notificationList
                      .isNotEmpty
                  ? context.read<NotificationProvider>().notificationList[0]
                  : Container(),
            ),
          ),
          showPrint(),
        ],
      ),
    );
  }

  connect() async {
    bool result = await AppConfig.initDatabase();
    setState(() {
      _isDbconnected = result == null
          ? -1
          : result
              ? 1
              : 0;
    });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _host,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Host",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 300,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _port,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Port",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 300,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _user,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Utilisateur",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: 300,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _password,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mot de passe",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Container(
          alignment: Alignment.center,
          child: Text(AppConfig.DB_ERROR),
        ),
        TextButton(
          onPressed: () async {
            AppConfig.preferences!.setString("ip", _host.text);
            AppConfig.preferences!.setInt("port", int.parse(_port.text));
            AppConfig.preferences!.setString("user", _user.text);
            AppConfig.preferences!.setString("password", _password.text);

            AppConfig.ip = AppConfig.preferences!.getString('ip');
            AppConfig.port = AppConfig.preferences!.getInt('port');
            AppConfig.user = AppConfig.preferences!.getString('user');
            AppConfig.password = AppConfig.preferences!.getString('password');
            setState(() {
              _isDbconnected = -1;
            });
            connect();
          },
          child: const Text("Réessayer"),
        ),
      ],
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Colors
                  .black //const Color.fromARGB(255, 182, 199, 206).withAlpha(100),
              ),
          child: const SideMenu(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: _screens[context.watch<LayoutProvider>().screenIndex],
          ),
        ),
      ],
    );
  }

  Widget showPrint() {
    TextEditingController _benficiary = TextEditingController();
    double heigth = context.read<LayoutProvider>().isPrintDisplayed
        ? MediaQuery.of(context).size.height - 90
        : 0;
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 80, right: 10, bottom: 15),
        height: heigth,
        width: context.watch<LayoutProvider>().isPrintDisplayed ? 450 : 0,
        child: Card(
            elevation: 10,
            child: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text("Produit"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Code-Barre"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Depot"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Quantite"),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.7,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.watch<ProductProvider>().removeList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: Column(
                          children: [
                            Container(
                              height: 0.5,
                            ),
                            const Spacer(),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(context
                                        .read<ProductProvider>()
                                        .removeList[index]
                                        .name),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      context
                                          .read<ProductProvider>()
                                          .removeList[index]
                                          .barcode,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      context
                                          .read<ProductProvider>()
                                          .removeList[index]
                                          .warehouse
                                          .name,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${context.read<ProductProvider>().removeList[index].remove}${context.read<ProductProvider>().removeList[index].unit}",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<ProductProvider>()
                                          .removeFromRemoveList(index);
                                    },
                                    child: const Icon(
                                      Icons.cancel_outlined,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 0.7,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: _benficiary,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "Benificaire",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                          onPressed: () async {
                            await printDoc(context: context);
                            await context
                                .read<ProductProvider>()
                                .remove(context: context);
                          },
                          child: const Text("Imprimer")),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
