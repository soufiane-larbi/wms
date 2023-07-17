import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/history_type.dart';
import 'package:whm/helper/provider/history_provider.dart';
import 'package:whm/layout/app_bar.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          margin: const EdgeInsets.only(
            top: 8,
            right: 8,
            left: 8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const StockToolBar(),
        ),
        Expanded(
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(
                    top: 8,
                    right: 8,
                    left: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  child: historyHeader(),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 60 - 24 - 40,
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(
                      right: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      itemCount:
                          context.watch<HistoryProvider>().historyList.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: historyItem(
                            context: context,
                            history: context
                                .read<HistoryProvider>()
                                .historyList[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget historyHeader() {
    return Row(
      children: const [
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: Text('Utilisateur'),
        ),
        Expanded(
          flex: 2,
          child: Text('Produit'),
        ),
        Expanded(
          flex: 2,
          child: Text('Catégorie'),
        ),
        Expanded(
          flex: 2,
          child: Text('Entrepôt'),
        ),
        Expanded(
          flex: 2,
          child: Text('Quantité/Unité'),
        ),
        Expanded(
          flex: 3,
          child: Text('Date'),
        ),
      ],
    );
  }

  Widget historyItem({HistoryType? history, context}) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      width: double.maxFinite,
      height: history!.productOld!.name == null ? 40 : 70,
      child: Column(
        children: [
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.grey,
          ),
          const Spacer(),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(history!.user!),
              ),
              Expanded(
                flex: 2,
                child: Text(history.productNew!.name!),
              ),
              Expanded(
                flex: 2,
                child: Text(history.productNew!.category!.name!),
              ),
              Expanded(
                flex: 2,
                child: Text(history.productNew!.warehouse!.name!),
              ),
              Expanded(
                flex: 2,
                child: Text(
                    "${history.productNew!.quantity!}${history.productNew!.unit!}"),
              ),
              Expanded(
                flex: 3,
                child: Text(history.date!.toString()),
              ),
            ],
          ),
          if (history.productOld!.name != null) const Spacer(),
          if (history.productOld!.name != null)
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 10,
                ),
                const Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 2,
                  child: Text(history.productOld!.name!),
                ),
                Expanded(
                  flex: 2,
                  child: Text(history.productOld!.category!.name!),
                ),
                Expanded(
                  flex: 2,
                  child: Text(history.productOld!.warehouse!.name!),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                      "${history.productOld!.quantity!}${history.productOld!.unit!}"),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
