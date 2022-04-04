import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/layout/app_bar.dart';
import 'layout/stock.dart';

void main() {
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
  Home({Key? key}) : super(key: key);

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
              child: Stock(),
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
          child: Text('Type'),
        ),
        Expanded(
          flex: 13,
          child: Text('Fournisseur'),
        ),
        Expanded(
          flex: 7,
          child: Text('Contenaire'),
        ),
        Expanded(
          flex: 7,
          child: Text('Batch'),
        ),
        Expanded(
          flex: 7,
          child: Text('Quantiy'),
        ),
        Expanded(
          flex: 7,
          child: Text('Restant'),
        ),
        Expanded(
          flex: 7,
          child: Text('Retour'),
        ),
        Expanded(
          flex: 7,
          child: Text('Casse'),
        ),
        Expanded(
          flex: 7,
          child: Text('Date Rec'),
        ),
        Expanded(
          flex: 7,
          child: Text('Fabrication'),
        ),
        Expanded(
          flex: 7,
          child: Text('date d\'Exp'),
        ),
        Expanded(
          flex: 5,
          child: Text('Zone'),
        ),
        Expanded(
          flex: 7,
          child: Text('Commentaire'),
        ),
      ],
    );
  }
}
