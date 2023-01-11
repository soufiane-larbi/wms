import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/stock_provider.dart';
import 'app_bar.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({Key? key}) : super(key: key);

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
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
          child: returnHeader(),
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
            child: returnListView(),
          ),
        ),
      ],
    );
  }

  Widget returnListView() {
    return ListView.builder(
      itemCount: context.watch<StockProvider>().returnList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<StockProvider>().changeReturnSelected(index);
          },
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: context.watch<StockProvider>().returnSelected == index
                  ? Colors.blue
                  : Colors.transparent,
            ),
            child: returnItem(
              context.read<StockProvider>().returnList[index],
              index,
            ),
          ),
        );
      },
    );
  }

  Widget returnHeader() {
    return Row(
      children: const [
        SizedBox(width: 6),
        Expanded(
          flex: 10,
          child: Text('Code Article'),
        ),
        Expanded(
          flex: 10,
          child: Text('Désignation'),
        ),
        Expanded(
          flex: 10,
          child: Text('Produit'),
        ),
        Expanded(
          flex: 6,
          child: Text('Prix'),
        ),
        Expanded(
          flex: 6,
          child: Text('Quantité'),
        ),
        Expanded(
          flex: 6,
          child: Text('Ticket'),
        ),
        Expanded(
          flex: 10,
          child: Text('Bénéficiaire'),
        ),
        Expanded(
          flex: 5,
          child: Text('Statu'),
        ),
        Expanded(
          flex: 10,
          child: Text('Date'),
        ),
      ],
    );
  }

  Widget returnItem(item, index) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 14,
            child: Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: item['status'] == 0
                    ? Colors.orange[800]
                    : item['status'] == 1
                        ? Colors.green[500]
                        : Colors.red[800],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              item['pdr'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              item['name'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              item['product'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              item['price'].toString() + ' DZD',
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              item['quantity'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              item['ticket'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              item['beneficiary'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              item['status'] == 0 ? 'En Attende' : 'Retourne',
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              item['date'].toString(),
              style: TextStyle(
                  color: context.watch<StockProvider>().returnSelected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
