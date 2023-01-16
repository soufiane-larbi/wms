import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/layout/app_bar.dart';
import '../helper/provider/bon_provider.dart';

class BonScreen extends StatefulWidget {
  const BonScreen({Key? key}) : super(key: key);

  @override
  State<BonScreen> createState() => _BonScreenState();
}

class _BonScreenState extends State<BonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
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
            child: bonHeader(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                right: 8,
                left: 8,
                bottom: 8,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: bonListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget bonListView() {
    return ListView.builder(
      itemCount: context.watch<BonProvider>().bonList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<BonProvider>().changeSelected(index);
          },
          child: bonItem(
            context.watch<BonProvider>().bonList[index],
            index,
          ),
        );
      },
    );
  }

  Widget bonHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 2,
          child: Text('Utilisateur'),
        ),
        Expanded(
          flex: 4,
          child: Text('Bénéficiaire'),
        ),
        Expanded(
          flex: 3,
          child: Text('Ticket'),
        ),
        Expanded(
          flex: 7,
          child: Text('Details'),
        ),
        Expanded(
          flex: 2,
          child: Text('Total'),
        ),
        Expanded(
          flex: 3,
          child: Text('Dernier Modification'),
        ),
      ],
    );
  }

  Widget bonItem(item, index) {
    double height = (jsonDecode(item['history'])).length * 40.0;
    return Container(
      height: height + 1,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.watch<BonProvider>().selected == index
            ? Colors.blue
            : Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.grey,
          ),
          const Spacer(),
          SizedBox(
            height: height,
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item['user'].toString(),
                    style: TextStyle(
                        color: context.watch<BonProvider>().selected == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    item['beneficiary'].toString(),
                    style: TextStyle(
                        color: context.watch<BonProvider>().selected == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    item['ticket'].toString(),
                    style: TextStyle(
                        color: context.watch<BonProvider>().selected == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: detail(
                    json: item['history'],
                    index: index,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    item['total'].toString() + ' DZD',
                    style: TextStyle(
                        color: context.watch<BonProvider>().selected == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    item['date'].toString(),
                    style: TextStyle(
                        color: context.watch<BonProvider>().selected == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(
            height: 0.5,
          ),
        ],
      ),
    );
  }

  Widget detail({required String json, required index}) {
    var bon = jsonDecode(json);
    return ListView.builder(
      itemCount: bon.length,
      itemBuilder: (context, i) {
        return Container(
          alignment: Alignment.centerLeft,
          height: 40,
          child: Text(
            'Code Article: ${bon[i]['pdrId']}'
            ', Quantité: ${bon[i]['quantity']}'
            ', Prix/U: ${bon[i]['price']} DZD',
            style: TextStyle(
              color: context.watch<BonProvider>().selected == index
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        );
      },
    );
  }
}
