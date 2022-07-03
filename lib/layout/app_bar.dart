import 'package:flutter/material.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/layout/history.dart';
import 'package:whm/layout/remove_stock.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'add_stock.dart';

class StockToolBar extends StatefulWidget {
  const StockToolBar({Key? key}) : super(key: key);

  @override
  State<StockToolBar> createState() => _StockToolBarState();
}

class _StockToolBarState extends State<StockToolBar> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<HistoryProvider>().historyList.length < 100,
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          children: [
            Expanded(
              child: search(),
            ),
            SizedBox(
              width: 270,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 50,
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<StockProvider>()
                                          .setDB(query: '''delete from stock 
                                      where id=${context.read<StockProvider>().stockList[context.read<StockProvider>().selected]['id']}''');
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Supprimer',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Annuler',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return const AlertDialog(
                            content: SizedBox(
                              width: 500,
                              height: 400,
                              child: AddStock(),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (contexttt) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 180,
                              height: 143,
                              child: RemoveStock(
                                stock: context.watch<StockProvider>().stockList[
                                    context.watch<StockProvider>().selected],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.remove_circle_outline_outlined,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.read<HistoryProvider>().setHistoryList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return const History();
                        }),
                      );
                    },
                    child: Icon(
                      Icons.history,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget search() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _editingController,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Chercher",
              hintStyle: TextStyle(fontSize: 20),
            ),
            onChanged: (_) {
              context.read<StockProvider>().setStockList(
                    query:
                        "select * from stock where name like '%${_editingController.text}%'",
                  );
            },
          ),
        ),
        InkWell(
          onTap: () async {},
          child: Icon(
            _editingController.text == ''
                ? Icons.search
                : Icons.cancel_outlined,
            size: 35,
          ),
        ),
      ],
    );
  }
}
