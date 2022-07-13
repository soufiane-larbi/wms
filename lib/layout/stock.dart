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
                  : Colors.white,
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
          child: Text('Nom'),
        ),
        Expanded(
          flex: 13,
          child: Text('Model'),
        ),
        Expanded(
          flex: 13,
          child: Text('Categorie'),
        ),
        Expanded(
          flex: 7,
          child: Text('SKU'),
        ),
        Expanded(
          flex: 7,
          child: Text('Quantity'),
        ),
        Expanded(
          flex: 7,
          child: Text('Restant'),
        ),
        Expanded(
          flex: 7,
          child: Text('Location'),
        ),
        Expanded(
          flex: 9,
          child: Text('Date De Creation'),
        ),
        Expanded(
          flex: 9,
          child: Text('Dernier Modification'),
        ),
      ],
    );
  }

  Widget stockItem(item, index) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Row(
        children: [
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
              item['model'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['catName'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['sku'].toString(),
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
            flex: 7,
            child: Text(
              item['remain'].toString(),
              style: TextStyle(
                  color: (item['remain'] ?? 0) < 10
                      ? Colors.amber
                      : context.watch<StockProvider>().selected == index
                          ? Colors.white
                          : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['zoneName'].toString(),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['creation_date'].toString(),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['modified_date'].toString(),
            ),
          ),
        ],
      ),
    );
  }
}
