import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/Formater/warehouse_type.dart';
import 'package:whm/helper/provider/warehouse_provider.dart';
import 'package:whm/layout/theme.dart';
import 'app_bar.dart';

class Warehouse extends StatefulWidget {
  const Warehouse({Key? key}) : super(key: key);

  @override
  State<Warehouse> createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    child: warehouseListView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget warehouseListView() {
    return ListView.builder(
      itemCount: context.watch<WarehouseProvider>().wahrehouseList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<WarehouseProvider>().changeSelected(index);
          },
          child: stockItem(
            context.watch<WarehouseProvider>().wahrehouseList[index],
            index,
          ),
        );
      },
    );
  }

  Widget stockHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 1,
          child: Text('Entrepôt'),
        ),
        Expanded(
          flex: 1,
          child: Text('Location'),
        ),
        Expanded(
          flex: 2,
          child: Text('Description'),
        ),
        Expanded(
          flex: 1,
          child: Text('Dernier Modification'),
        ),
        Expanded(
          flex: 1,
          child: Text('Date De Création'),
        ),
      ],
    );
  }

  Widget stockItem(WarehouseType warehouse, index) {
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
      child: Container(
        height: 40,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.watch<WarehouseProvider>().selected == index
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
                  child: Text(
                    warehouse.name!,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    warehouse.location!,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    warehouse.description!,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    warehouse.modifiedDate!.toString(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    warehouse.creationDate!.toString(),
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
