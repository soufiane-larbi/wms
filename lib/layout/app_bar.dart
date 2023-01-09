import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whm/helper/provider/bon_provider.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';
import 'package:whm/layout/add_bon.dart';
import 'package:whm/layout/remove_stock.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import '../helper/print.dart';
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
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          children: [
            Expanded(
              child: searchField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: 'Admin' == context.watch<UserProvider>().role &&
                      context.read<LayoutProvider>().screenIndex == 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
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
                                        String pdr = context
                                                .read<StockProvider>()
                                                .stockList[
                                            context
                                                .read<StockProvider>()
                                                .selected]['id'];
                                        int quantity = context
                                                .read<StockProvider>()
                                                .stockList[
                                            context
                                                .read<StockProvider>()
                                                .selected]['quantity'];
                                        context
                                            .read<StockProvider>()
                                            .updateStockQuantity(
                                              pdrId: pdr,
                                              newQuantity: 0,
                                            );
                                        context
                                            .read<HistoryProvider>()
                                            .addHistory(
                                              user: context
                                                  .read<UserProvider>()
                                                  .user,
                                              pdr: pdr,
                                              operation: 'Supprimer',
                                              newQuantity: quantity,
                                            );
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
                  ),
                ),
                Visibility(
                  visible: context.read<LayoutProvider>().screenIndex == 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return const AlertDialog(
                              title: Text("Ajouter PDR"),
                              content: SizedBox(
                                width: 410,
                                height: 280,
                                child: AddStock(),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.move_to_inbox,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: context.read<LayoutProvider>().screenIndex == 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Bon de Commande"),
                              content: SizedBox(
                                width: 410,
                                height: 280,
                                child: RemoveStock(
                                  pdrID:
                                      context.read<StockProvider>().stockList[
                                          context
                                              .read<StockProvider>()
                                              .selected]['id'],
                                  pdrPrice:
                                      context.read<StockProvider>().stockList[
                                          context
                                              .read<StockProvider>()
                                              .selected]['price'],
                                  beneficiary:
                                      context.read<BonProvider>().beneficiary,
                                  ticket: context.read<BonProvider>().ticket,
                                  quantity:
                                      context.read<StockProvider>().stockList[
                                          context
                                              .read<StockProvider>()
                                              .selected]['quantity'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.outbox_rounded,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: context.read<LayoutProvider>().screenIndex == 0 ||
                      context.read<LayoutProvider>().screenIndex == 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () async {
                        try {
                          if (context.read<LayoutProvider>().screenIndex == 0) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const BonCommande();
                              },
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Chargement...",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.grey,
                            ),
                          );

                          List<dynamic> bon = jsonDecode(context
                                  .read<BonProvider>()
                                  .bonList[context.read<BonProvider>().selected]
                              ['history']);
                          await printDoc(context: context, bon: bon);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error: $e",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.print_rounded,
                              color: Colors.grey[600],
                              size: 40,
                            ),
                            Visibility(
                              visible:
                                  context.read<LayoutProvider>().screenIndex ==
                                      0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    context
                                        .watch<BonProvider>()
                                        .temBonList
                                        .length
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: context.read<LayoutProvider>().screenIndex == 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                      child: InkWell(
                        onTap: () {
                          int index =
                              context.read<StockProvider>().returnSelected;
                          int returnId = context
                              .read<StockProvider>()
                              .returnList[index]['id'];
                          String pdr = context
                              .read<StockProvider>()
                              .returnList[index]['pdr'];
                          if (context.read<StockProvider>().returnList[index]
                                  ['status'] !=
                              0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "$pdr a été déja retourné",
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                      "${context.read<StockProvider>().returnList[context.read<StockProvider>().returnSelected]['pdr']}"),
                                ),
                                content: SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Annuler',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<StockProvider>()
                                              .updateReturnStatus(
                                                returnId: returnId,
                                                status: 1,
                                              );
                                          context
                                              .read<HistoryProvider>()
                                              .addHistory(
                                                user: context
                                                    .read<UserProvider>()
                                                    .user,
                                                pdr: pdr,
                                                operation: 'Retourn',
                                                ticket: context
                                                        .read<StockProvider>()
                                                        .returnList[
                                                    context
                                                        .read<StockProvider>()
                                                        .returnSelected]['ticket'],
                                                beneficiary: context
                                                            .read<StockProvider>()
                                                            .returnList[
                                                        context
                                                            .read<StockProvider>()
                                                            .returnSelected]
                                                    ['beneficiary'],
                                                newQuantity: context
                                                            .read<StockProvider>()
                                                            .returnList[
                                                        context
                                                            .read<StockProvider>()
                                                            .returnSelected]
                                                    ['quantity'],
                                              );
                                          context
                                              .read<StockProvider>()
                                              .changeReturnSelected(0);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "$pdr a été retourné",
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Confirmer Le Retour',
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
                          Icons.arrow_circle_down_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              controller: _editingController,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: searchHint(),
                hintStyle: const TextStyle(fontSize: 20),
              ),
              onChanged: (_) {
                search();
              },
            ),
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

  search() {
    if (context.read<LayoutProvider>().screenIndex == 0) {
      context.read<StockProvider>().setStockList(
        filter: '''
                    WHERE (id LIKE '%${_editingController.text}%'
                    OR name LIKE '%${_editingController.text}%'
                    OR product LIKE '%${_editingController.text}%') 
                  ''',
      );
      return;
    }
    if (context.read<LayoutProvider>().screenIndex == 1) {
      context.read<StockProvider>().setReturnList(
        filter: '''
                    WHERE (pdr.id LIKE '%${_editingController.text}%'
                    OR pdr.name LIKE '%${_editingController.text}%'
                    OR pdr.product LIKE '%${_editingController.text}%'
                    OR returnPdr.ticket LIKE '%${_editingController.text}%'
                    OR returnPdr.beneficiary LIKE '%${_editingController.text}%'
                    ) 
                  ''',
      );
      return;
    }
    if (context.read<LayoutProvider>().screenIndex == 2) {
      context.read<BonProvider>().setBonList(
        filter: '''
                    WHERE history like '%${_editingController.text}%'
                  ''',
      );
      return;
    }
    if (context.read<LayoutProvider>().screenIndex == 3) {
      context.read<HistoryProvider>().setHistoryList(
        filter: '''
                    WHERE pdr.id LIKE '%${_editingController.text}%'
                    OR history.ticket LIKE '%${_editingController.text}%'
                    OR history.beneficiary LIKE '%${_editingController.text}%'
                  ''',
      );
      return;
    }
  }

  String searchHint() {
    if (context.read<LayoutProvider>().screenIndex == 0) {
      return 'Code Article, Désignation et Produit';
    }
    if (context.read<LayoutProvider>().screenIndex == 1) {
      return 'Code Article, Désignation, Produit, Ticket et Bénéficiaire';
    }
    if (context.read<LayoutProvider>().screenIndex == 2) {
      return 'Code Article, Ticket et Bénéficiaire';
    }
    if (context.read<LayoutProvider>().screenIndex == 3) {
      return 'Code Article, Ticket et Bénéficiaire';
    }
    return 'Chercher';
  }
}
