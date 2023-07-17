import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/config.dart';
import 'package:whm/helper/provider/user_provider.dart';

import '../helper/provider/category_provider.dart';
import '../helper/provider/history_provider.dart';
import '../helper/provider/product_provider.dart';
import '../helper/provider/warehouse_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _login = 'Connecter';
  bool _remembrMe = false;

  @override
  void initState() {
    if (AppConfig.preferences!.getBool("rememberMe") ?? false) {
      _userController.text = AppConfig.preferences!.getString("username") ?? '';
      _passwordController.text =
          AppConfig.preferences!.getString("userPassword") ?? '';
      _remembrMe = AppConfig.preferences!.getBool("rememberMe") ?? false;
      login();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: SizedBox(
        height: 350,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.jpg',
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: 300,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _userController,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Utilisateur",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              width: 300,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mot De Passe",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () async {
                    setState(() {
                      _login = 'Connexion';
                    });
                    login();
                  },
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _login,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: _remembrMe,
                          onChanged: (value) {
                            setState(() {
                              _remembrMe = value!;
                              AppConfig.preferences!
                                  .setString("username", _userController.text);
                              AppConfig.preferences!.setString(
                                  "userPassword", _passwordController.text);
                              AppConfig.preferences!
                                  .setBool("rememberMe", _remembrMe);
                            });
                          }),
                      const Text("Remember me"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    var result = await context.read<UserProvider>().auth(
          user: _userController.text,
          password: _passwordController.text,
        );
    if (result is bool) {
      try {
        context.read<ProductProvider>().setList(context: context);
        context.read<CategoryProvider>().setList(context: context);
        context.read<WarehouseProvider>().setList(context: context);
        context.read<HistoryProvider>().setList();
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
    setState(() {
      _login = 'Connecter';
      _passwordController.text = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Utilisateur ou Mot de pass est incorrect.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
