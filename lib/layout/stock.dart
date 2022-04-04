import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  @override
  Widget build(BuildContext context) {
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
                color: context.watch<StockProvider>().selected == index ? Colors.blue : Colors.white,
              ),
              child: stockItem(
                context.watch<StockProvider>().stockList[index],
                index,
              ),
            ),
          );
        });
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
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['type'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              item['provider'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['container'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['batch'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['quantity'].toString(),
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
              item['return'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['broken'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['recieved_date'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['made_date'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['expiration_date'].toString(),
              style: TextStyle(
                color: expireSoon(item)
                    ? Colors.amber
                    : context.watch<StockProvider>().selected == index
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              item['stocking_zone'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              item['comment'].toString(),
              style: TextStyle(color: context.watch<StockProvider>().selected == index ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  bool expireSoon(item) {
    var exp = item['expiration_date'].toString().split('/');
    DateTime now = DateTime.now();

    if (exp.length == 3) {
      if (int.parse(exp[2]) - now.year > 1) return false;
      if (int.parse(exp[1]) - now.month > 6) return false;
    }
    return true;
  }
}
