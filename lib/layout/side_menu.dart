import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';

import '../helper/provider/bon_provider.dart';
import '../helper/provider/history_provider.dart';
import '../helper/provider/stock_provider.dart';

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
        menu(
          title: 'Produits',
          index: 0,
          icon: Icons.horizontal_split_outlined,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'PDRs S/G',
          index: 1,
          icon: Icons.horizontal_split_outlined,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Bons',
          index: 2,
          icon: Icons.difference_outlined,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Historiques',
          index: 3,
          icon: Icons.history_rounded,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Tableau De Bord',
          index: 4,
          icon: Icons.incomplete_circle_rounded,
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(8),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    logout();
                  },
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(context.read<UserProvider>().name),
              ],
            ),
          ),
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

  logout() {
    context.read<UserProvider>().reset();
    context.read<StockProvider>().reset();
    context.read<HistoryProvider>().setHistoryList();
    context.read<BonProvider>().reset();
    context.read<LayoutProvider>().setScreenIndex(0);
  }
}
