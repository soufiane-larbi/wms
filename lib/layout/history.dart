import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: const StockToolBar(),
        ),
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
              itemCount: context.watch<HistoryProvider>().historyList.length,
              itemBuilder: (_, index) {
                return historyItem(
                  context: context,
                  history: context.read<HistoryProvider>().historyList[index],
                );
              },
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
          width: 6,
        ),
        Expanded(
          flex: 2,
          child: Text('Code Article'),
        ),
        Expanded(
          flex: 2,
          child: Text('Désignation'),
        ),
        Expanded(
          flex: 2,
          child: Text('Ticket'),
        ),
        Expanded(
          flex: 2,
          child: Text('Bénéficiaire'),
        ),
        Expanded(
          flex: 3,
          child: Text('Opération'),
        ),
        Expanded(
          flex: 1,
          child: Text('Quantité'),
        ),
        Expanded(
          flex: 1,
          child: Text('Prix'),
        ),
        Expanded(
          flex: 2,
          child: Text('Utilisateur'),
        ),
        Expanded(
          flex: 2,
          child: Text('Date'),
        ),
      ],
    );
  }

  Widget historyItem({history, context}) {
    int lines = (history['operation'].toString().length / 40).round();
    // lines = lines == 0 ? 0 : lines;
    double height = 42.0 + lines * 15.0;
    return Container(
      padding: const EdgeInsets.only(right: 8),
      width: double.maxFinite,
      height: height,
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
              Container(
                alignment: Alignment.center,
                width: 16,
                child: Container(
                  height: 20,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: history['operation'].toString().contains('Sortie')
                        ? Colors.orange[800]
                        : history['operation'].toString().contains('Ajouter')
                            ? Colors.green[500]
                            : history['operation'].toString().contains('Retour')
                                ? Colors.purple
                                : history['operation']
                                        .toString()
                                        .contains('Modifier')
                                    ? Colors.blue
                                    : Colors.red[800],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(history['id'].toString()),
              ),
              Expanded(
                flex: 2,
                child: Text(history['name'].toString()),
              ),
              Expanded(
                flex: 2,
                child: Text(history['ticket'].toString()),
              ),
              Expanded(
                flex: 2,
                child: Text(history['beneficiary'].toString()),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  history['operation'].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: lines < 1 ? 1 : lines + 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(history['new_quantity'].toString()),
              ),
              Expanded(
                flex: 1,
                child: Text(history['price'].toString()),
              ),
              Expanded(
                flex: 2,
                child: Text(history['user'].toString()),
              ),
              Expanded(
                flex: 2,
                child: Text(history['date'].toString()),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
