import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/print.dart';
import 'package:whm/helper/provider/bon_provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';

class BonCommande extends StatefulWidget {
  const BonCommande({Key? key}) : super(key: key);

  @override
  State<BonCommande> createState() => _BonCommandeState();
}

class _BonCommandeState extends State<BonCommande> {
  final List<bool> _focus = [];
  bool _loading = false;
  @override
  void initState() {
    for (var _ in context.read<BonProvider>().temBonList) {
      _focus.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text(
              '''Bons de Commande [Total: ${context.watch<BonProvider>().totalPrice} DZD ${context.watch<BonProvider>().underWarranty > 0 ? ', ${context.watch<BonProvider>().underWarranty} Sous Garantie' : ''}]'''),
          actions: [
            TextButton(
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer et Imprimé'),
              onPressed: () async {
                if (context.read<BonProvider>().temBonList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "La liste est vide.",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  Navigator.of(context).pop();
                  return;
                }
                setState(() {
                  _loading = true;
                });
                await printDoc(
                    context: context,
                    bon: context.read<BonProvider>().temBonList);
                int insertedID = await context.read<BonProvider>().addBon(
                      history: jsonEncode(
                        context.read<BonProvider>().temBonList,
                      ),
                      user: context.read<UserProvider>().name,
                      beneficiary: context.read<BonProvider>().beneficiary,
                      ticket: context.read<BonProvider>().ticket,
                      reset: false,
                    );
                for (var bon in context.read<BonProvider>().temBonList) {
                  int? quantity = await context
                      .read<StockProvider>()
                      .getQuantity(pdr: bon['pdrId']);
                  double? price = await context
                      .read<StockProvider>()
                      .getPrice(pdr: bon['pdrId']);
                  int? newQuantity = quantity - bon['quantity'] as int;
                  context.read<HistoryProvider>().addHistory(
                        user: context.read<UserProvider>().user,
                        ticket: bon['ticket'],
                        beneficiary: bon['beneficiary'],
                        pdr: bon['pdrId'],
                        operation: 'Sortie',
                        previousQuantity: newQuantity,
                        newQuantity: bon['quantity'],
                        price: bon['price'] * bon['quantity'],
                      );
                  if (bon['price'] == 0.0) {
                    await context.read<StockProvider>().addReturn(
                          pdr: bon['pdrId'],
                          quantity: bon['quantity'],
                          beneficiary: bon['beneficiary'],
                          ticket: bon['ticket'],
                          price: price * bon['quantity'],
                          bon: insertedID,
                        );
                  }
                  await context.read<StockProvider>().updateStockQuantity(
                        newQuantity: newQuantity,
                        pdrId: bon['pdrId'],
                      );
                }
                context.read<BonProvider>().manualReset();
                setState(() {
                  _loading = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
          content: SizedBox(
            width: 750,
            height: 350,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 30,
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 1,
                        child: Text('Ticket'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Bénéficiaire'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Code Article'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Prix'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Quantité'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Total'),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.blueGrey,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: context.read<BonProvider>().temBonList.length,
                    itemBuilder: (context, index) {
                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _focus[index] = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _focus[index] = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _focus[index] ? Colors.blue : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.read<BonProvider>().temBonList[index]
                                          ['ticket'] ??
                                      '-',
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  context.read<BonProvider>().temBonList[index]
                                          ['beneficiary'] ??
                                      '-',
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  context.read<BonProvider>().temBonList[index]
                                          ['pdrId'] ??
                                      '-',
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  warranty(
                                    price: context
                                        .read<BonProvider>()
                                        .temBonList[index]['price'],
                                  ),
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  context
                                      .read<BonProvider>()
                                      .temBonList[index]['quantity']
                                      .toString(),
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  warranty(
                                    price: context
                                        .read<BonProvider>()
                                        .temBonList[index]['price'],
                                    quantity: context
                                        .read<BonProvider>()
                                        .temBonList[index]['quantity'],
                                  ),
                                  style: TextStyle(
                                    color: _focus[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      context
                                          .read<BonProvider>()
                                          .removeItemFromTempBon(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel_sharp,
                                    size: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _loading,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  String warranty({price, quantity = 1}) {
    return price == 0 ? "Sous Garantie" : '${price * quantity} DZD';
  }
}
