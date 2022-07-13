import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/provider/zone_provider.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({Key? key}) : super(key: key);

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addZone();
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
            child: zoneHeader(),
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
              child: zoneListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget zoneListView() {
    return ListView.builder(
      itemCount: context.watch<ZoneProvider>().categoryList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<ZoneProvider>().changeSelected(index);
          },
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: context.watch<ZoneProvider>().selected == index
                  ? Colors.blue
                  : Colors.white,
            ),
            child: zoneItem(
              context.watch<ZoneProvider>().categoryList[index],
              index,
            ),
          ),
        );
      },
    );
  }

  Widget zoneHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 9,
          child: Text('Nom'),
        ),
        Expanded(
          flex: 18,
          child: Text('Addresse'),
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

  Widget zoneItem(item, index) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(
              item['name'].toString(),
              style: TextStyle(
                  color: context.watch<ZoneProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              item['address'].toString(),
              style: TextStyle(
                  color: context.watch<ZoneProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['creation_date'].toString(),
              style: TextStyle(
                  color: context.watch<ZoneProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              item['modified_date'].toString(),
              style: TextStyle(
                  color: context.watch<ZoneProvider>().selected == index
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  addZone() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Center(child: Text("Entrez le nom de la location")),
          content: SizedBox(
            width: 320,
            height: 205,
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
                    controller: _nameController,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nom",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 90,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _addressController,
                    maxLines: 10,
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Address...",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    context.read<ZoneProvider>().query(query: '''
                        INSERT INTO zone(name,address,creation_date) 
                        VALUES('${_nameController.text}','${_addressController.text}',NOW())
                      ''');
                    Navigator.of(context).pop();
                    _addressController.text = _nameController.text = '';
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
