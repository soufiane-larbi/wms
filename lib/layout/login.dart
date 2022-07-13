import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/user_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _connected = false;
  String _login = 'Connecter';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            height: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('Utilisateur'),
              ),
              Container(
                height: 40,
                width: 230,
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
                    hintText: "",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('Mot de passe'),
              ),
              Container(
                height: 40,
                width: 230,
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
                    hintText: "",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                _login = 'Connexion';
              });
              await context
                  .read<UserProvider>()
                  .setUserList(query: '''where user = '${_userController.text}' 
                and password = '${_passwordController.text}'
                ''').then(
                (_) {
                  setState(() {
                    _connected =
                        context.read<UserProvider>().userList.length > 0;
                    if (!_connected) {
                      setState(() {
                        _login = 'Connecter';
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
                      return;
                    }
                    context.read<UserProvider>().setConnected(true);
                  });
                },
              );
            },
            child: Container(
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blueGrey[400],
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
        ],
      ),
    );
  }
}
