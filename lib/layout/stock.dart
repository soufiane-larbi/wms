import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'app_bar.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              bottom: 8,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: stockListView(),
          ),
        ),
      ],
    );
  }

  Widget stockListView() {
    return ListView.builder(
      itemCount: context.watch<StockProvider>().stockList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<StockProvider>().changeSelected(index);
          },
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: context.watch<StockProvider>().selected == index
                  ? Colors.blue
                  : Colors.transparent,
            ),
            child: stockItem(
              context.watch<StockProvider>().stockList[index],
              index,
            ),
          ),
        );
      },
    );
  }

  Widget stockHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 13,
          child: Text('Code Article'),
        ),
        Expanded(
          flex: 13,
          child: Text('Désignation'),
        ),
        Expanded(
          flex: 13,
          child: Text('Produit'),
        ),
        Expanded(
          flex: 13,
          child: Text('Prix'),
        ),
        Expanded(
          flex: 7,
          child: Text('Quantité'),
        ),
        Expanded(
          flex: 9,
          child: Text('Dernier Modification'),
        ),
        Expanded(
          flex: 9,
          child: Text('Date De Création'),
        ),
      ],
    );
  }

  Widget stockItem(item, index) {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            flex: 13,
            child: Text(
              item['id'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['name'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['product'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['price'].toString() + ' DZD',
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['quantity'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['modified_date'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['creation_date'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
