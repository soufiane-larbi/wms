import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 160,
          width: 200,
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        menu(
          title: 'Produits',
          index: 0,
          icon: Icons.horizontal_split_outlined,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Categorie',
          index: 1,
          icon: Icons.category,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Zone',
          index: 2,
          icon: Icons.warehouse,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Status',
          index: 3,
          icon: Icons.stacked_line_chart_sharp,
        ),
      ],
    );
  }

  Widget menu({icon, title, index}) {
    return InkWell(
      onTap: () {
        context.read<LayoutProvider>().setScreenIndex(index);
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        width: 180,
        height: context.watch<LayoutProvider>().screenIndex == index ? 180 : 50,
        padding: const EdgeInsets.all(10),
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: context.watch<LayoutProvider>().screenIndex == index
              ? Colors.blue
              : Colors.blueGrey[100],
        ),
        child: Column(
          children: [
            Visibility(
              visible: context.watch<LayoutProvider>().screenIndex == index,
              child: Expanded(
                child: Icon(
                  icon,
                  size: 110,
                  color: context.watch<LayoutProvider>().screenIndex == index
                      ? Colors.white
                      : Colors.grey[700],
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: context.watch<LayoutProvider>().screenIndex == index
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile({picture, name}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
    );
  }
}
