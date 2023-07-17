import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/product_provider.dart';
import 'package:whm/layout/theme.dart';
import '../Formater/product_type.dart';
import 'app_bar.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
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
          ),
          child: const StockToolBar(),
        ),
        Expanded(
          child: Card(
            elevation: 5,
            child: Column(
              children: [
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
                Container(
                  height: 0.7,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.only(top: 5),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget stockListView() {
    return ListView.builder(
      itemCount: context.watch<ProductProvider>().productList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<ProductProvider>().changeSelected(index);
          },
          child: stockItem(
            context.watch<ProductProvider>().productList[index],
            index,
          ),
        );
      },
    );
  }

  Widget stockHeader() {
    return Row(
      children: const [
        Spacer(flex: 7),
        Expanded(
          flex: 13,
          child: Text('Produit'),
        ),
        Expanded(
          flex: 7,
          child: Text('Quantie'),
        ),
        Expanded(
          flex: 9,
          child: Text('Code a Barre'),
        ),
        Expanded(
          flex: 9,
          child: Text('Categorie'),
        ),
        Expanded(
          flex: 9,
          child: Text('Depot'),
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

  Widget stockItem(ProductType product, index) {
    bool hover = false;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: context.watch<ProductProvider>().selected == index ? 80 : 40,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.watch<ProductProvider>().selected == index
              ? AppTheme.itemSelcted
              : hover
                  ? AppTheme.itemHover
                  : AppTheme.itemNotSelected,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 0.1,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    height: context.watch<ProductProvider>().selected == index
                        ? 60
                        : 30,
                    width: 30,
                    child: product.image == null
                        ? Container()
                        : Image.memory(product.image!.toBytes() as Uint8List),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 13,
                  child: Text(
                    product.name!,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    "${(product.quantity! - (product.remove ?? 0))}${product.unit!}",
                    style: TextStyle(
                      color: product.remove == 0 ? Colors.black : Colors.orange,
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    product.barcode!,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    product.category!.name!,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    product.warehouse!.name!,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    product.modifiedDate!.toString(),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    product.creationDate!.toString(),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              color: Colors.grey[700],
              height: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
