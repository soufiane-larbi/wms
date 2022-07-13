import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCategory();
        },
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              child: categoryListView(),
            ),
          ),
        ],
      ),
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
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: context.watch<CategoryProvider>().selected == index
                  ? Colors.blue
                  : Colors.white,
            ),
            child: categoryItem(
              context.watch<CategoryProvider>().categoryList[index],
              index,
            ),
          ),
        );
      },
    );
  }

  Widget categoryHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 13,
          child: Text('Nom'),
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

  Widget categoryItem(item, index) {
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
                  color: context.watch<CategoryProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['creation_date'].toString(),
              style: TextStyle(
                  color: context.watch<CategoryProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['modified_date'].toString(),
              style: TextStyle(
                  color: context.watch<CategoryProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  addCategory() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Center(child: Text("Entrez le nom de la catégorie")),
          content: SizedBox(
            width: 320,
            height: 100,
            child: Column(
              children: [
                Container(
                  height: 45,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _categoryController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Categorie",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    context.read<CategoryProvider>().query(query: '''
                        INSERT INTO category(name,creation_date) VALUES('${_categoryController.text}',NOW())
                      ''');
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
