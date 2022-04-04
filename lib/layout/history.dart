import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/print.dart';
import 'package:whm/helper/provider/history_provider.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            width: double.maxFinite,
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
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.grey[600],
                    size: 40,
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 40),
                      child: Center(
                        child: Text(
                          'Historique',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text('Produit'),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Type'),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Fournisseur'),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Stock'),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Operation'),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Restant'),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Date'),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 60 - 24 - 40,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
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
                  history: context.watch<HistoryProvider>().historyList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget historyItem({history, context}) {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: InkWell(
        onTap: () async {
          await printDoc(context: context, product: history);
        },
        child: Column(
          children: [
            Container(
              height: 0.3,
              width: double.infinity,
              color: Colors.grey,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(history['name'].toString()),
                ),
                Expanded(
                  flex: 3,
                  child: Text(history['Type'] ?? 'N/A'),
                ),
                Expanded(
                  flex: 3,
                  child: Text(history['provider'] ?? 'N/A'),
                ),
                Expanded(
                  flex: 2,
                  child: Text(history['stock'].toString()),
                ),
                Expanded(
                  flex: 2,
                  child: Text(history['operation'].toString()),
                ),
                Expanded(
                  flex: 2,
                  child: Text(history['remain'].toString()),
                ),
                Expanded(
                  flex: 3,
                  child: Text(history['date'] + ' ' + history['time'] ?? 'N/A'),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(
              height: 0.3,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
