import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/category_type.dart';
import 'package:whm/layout/theme.dart';
import '../helper/provider/category_provider.dart';
import 'app_bar.dart';

class CategoryS extends StatefulWidget {
  const CategoryS({Key? key}) : super(key: key);

  @override
  State<CategoryS> createState() => _CategorySState();
}

class _CategorySState extends State<CategoryS> {
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
                  child: categoryHeader(),
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
                    child: categoryListView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryListView() {
    return ListView.builder(
      itemCount: context.watch<CategoryProvider>().categoryList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<CategoryProvider>().changeSelected(index);
          },
          child: categoryItem(
            context.watch<CategoryProvider>().categoryList[index],
            index,
          ),
        );
      },
    );
  }

  Widget categoryHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 1,
          child: Text(''),
        ),
        Expanded(
          flex: 3,
          child: Text('Categorie'),
        ),
        Expanded(
          flex: 3,
          child: Text('Dernier Modification'),
        ),
        Expanded(
          flex: 3,
          child: Text('Date De Création'),
        ),
      ],
    );
  }

  Widget categoryItem(CategoryType category, index) {
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
        height: context.watch<CategoryProvider>().selected == index ? 80 : 40,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.watch<CategoryProvider>().selected == index
              ? AppTheme.itemSelcted
              : hover
                  ? AppTheme.itemHover
                  : AppTheme.itemNotSelected,
        ),
        child: Column(
          children: [
            Container(
              height: 0.1,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SizedBox(
                      height:
                          context.watch<CategoryProvider>().selected == index
                              ? 75
                              : 35,
                      child: category.image != null
                          ? Image.memory(category.image!.toBytes() as Uint8List)
                          : Container(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    category.name!,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    category.modifiedDate!.toString(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    category.creationDate!.toString(),
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
