import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
          width: 200,
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

  Widget menu({icon, title, onTap, index}) {
    return InkWell(
      onTap: () {
        setState(() {
          _index = index;
        });
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        width: 180,
        height: _index == index ? 180 : 50,
        padding: const EdgeInsets.all(10),
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: _index == index ? Colors.blue : Colors.blueGrey[100],
        ),
        child: Column(
          children: [
            Visibility(
              visible: _index == index,
              child: Expanded(
                child: Icon(
                  icon,
                  size: 110,
                  color: _index == index ? Colors.white : Colors.grey[700],
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
                    color: _index == index ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
