import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:whm/Formater/product_type.dart';
import 'package:whm/helper/provider/category_provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/notification_provider.dart';
import 'package:whm/helper/provider/warehouse_provider.dart';
import 'package:whm/layout/add_category.dart';
import 'package:whm/layout/add_warehouse.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/product_provider.dart';
import 'package:whm/layout/remove_product.dart';
import 'add_product.dart';

class StockToolBar extends StatefulWidget {
  static final TextEditingController editingController =
      TextEditingController();
  const StockToolBar({Key? key}) : super(key: key);

  @override
  State<StockToolBar> createState() => _StockToolBarState();
}

class _StockToolBarState extends State<StockToolBar> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "WHM/${context.watch<LayoutProvider>().screenName}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            //Delete
            Visibility(
              visible: context.read<LayoutProvider>().screenIndex <= 2,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    if (context
                                            .read<LayoutProvider>()
                                            .screenIndex ==
                                        0) {
                                      await context
                                          .read<ProductProvider>()
                                          .delete(
                                            context: context,
                                          );
                                    }
                                    if (context
                                            .read<LayoutProvider>()
                                            .screenIndex ==
                                        1) {
                                      await context
                                          .read<CategoryProvider>()
                                          .delete(
                                            context: context,
                                          );
                                    }
                                    if (context
                                            .read<LayoutProvider>()
                                            .screenIndex ==
                                        2) {
                                      await context
                                          .read<WarehouseProvider>()
                                          .delete(
                                            context: context,
                                          );
                                    }
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Supprimer",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Edit
            Visibility(
              visible: context.read<LayoutProvider>().screenIndex <= 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    if (context.read<LayoutProvider>().screenIndex == 0) {
                      ProductType product =
                          context.read<ProductProvider>().productList[
                              context.read<ProductProvider>().selected];
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(
                                "Modifier: ${context.read<ProductProvider>().productList[context.read<ProductProvider>().selected].name}"),
                            content: SizedBox(
                              width: 410,
                              height: 280,
                              child: AddStock(
                                productOld: product,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (context.read<LayoutProvider>().screenIndex == 1) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(
                                "Modifier: ${context.read<CategoryProvider>().categoryList[context.read<CategoryProvider>().selected].name}"),
                            content: SizedBox(
                              width: 410,
                              height: 140,
                              child: AddCategory(
                                categoryOld: context
                                        .read<CategoryProvider>()
                                        .categoryList[
                                    context.read<CategoryProvider>().selected],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (context.read<LayoutProvider>().screenIndex == 2) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(
                                "Modifier: ${context.read<WarehouseProvider>().wahrehouseList[context.read<WarehouseProvider>().selected].name}"),
                            content: SizedBox(
                              width: 410,
                              height: 180,
                              child: AddWarehouse(
                                warehouse: context
                                        .read<WarehouseProvider>()
                                        .wahrehouseList[
                                    context.read<WarehouseProvider>().selected],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Modifier",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Add
            Visibility(
              visible: context.read<LayoutProvider>().screenIndex <= 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    String title =
                        context.read<LayoutProvider>().screenIndex == 0
                            ? "Produit"
                            : context.read<LayoutProvider>().screenIndex == 1
                                ? "Categorie"
                                : "Depot";
                    Widget addItem =
                        context.read<LayoutProvider>().screenIndex == 0
                            ? AddStock()
                            : context.read<LayoutProvider>().screenIndex == 1
                                ? AddCategory()
                                : AddWarehouse();
                    double height =
                        context.read<LayoutProvider>().screenIndex == 0
                            ? 280
                            : context.read<LayoutProvider>().screenIndex == 1
                                ? 135
                                : 180;

                    if (context.read<LayoutProvider>().screenIndex == 0 &&
                        (context
                                .read<WarehouseProvider>()
                                .wahrehouseList
                                .isEmpty ||
                            context
                                .read<CategoryProvider>()
                                .categoryList
                                .isEmpty)) {
                      context.read<NotificationProvider>().showNotification(
                            type: 1,
                            message:
                                "Vous avez besoin d'au moins une catégorie et un entrepôt pour ajouter un produit !",
                          );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Ajouter $title"),
                          content: SizedBox(
                            width: 410,
                            height: height,
                            child: addItem,
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Ajouter",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Remove
            Visibility(
              visible: context.read<LayoutProvider>().screenIndex == 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Remove"),
                            content: Container(
                              height: 100,
                              width: 370,
                              child: RemoveProduct(),
                            ),
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.outbox_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Retirer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Print
            Visibility(
              visible: context.read<LayoutProvider>().screenIndex == 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<LayoutProvider>().isPrintDisplayed
                            ? context.read<LayoutProvider>().hidePrint()
                            : context.read<LayoutProvider>().showPrint();
                      },
                      child: SizedBox(
                        height: 40,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.print_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Imprimer",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: context.read<LayoutProvider>().screenIndex == 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, left: 3.0),
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
                              '${context.watch<ProductProvider>().removeList.length}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
              enabled: context.read<LayoutProvider>().screenIndex == 0,
              controller: StockToolBar.editingController,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.read<LayoutProvider>().screenIndex == 0
                    ? "Recherche par nom, code-barres, catégorie et entrepôt"
                    : "Recherche non disponible",
                hintStyle: const TextStyle(fontSize: 20),
              ),
              onChanged: (_) {
                context.read<ProductProvider>().setList(
                      context: context,
                      filter: StockToolBar.editingController.text,
                    );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () async {},
          child: Icon(
            StockToolBar.editingController.text == ''
                ? Icons.search
                : Icons.cancel_outlined,
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget profile({Uint8List? picture, String? name}) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: picture != null
                    ? Center(
                        child: Text(
                          name!.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: MemoryImage(picture!),
                        backgroundColor: Colors.white,
                      ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(name!),
          ],
        ),
      ),
    );
  }
}
