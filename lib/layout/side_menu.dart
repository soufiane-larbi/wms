import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whm/helper/provider/layout_provider.dart';
import 'package:whm/helper/provider/user_provider.dart';
import '../helper/config.dart';
import '../helper/provider/history_provider.dart';
import '../helper/provider/product_provider.dart';
import 'app_bar.dart';
import 'package:rxdart/rxdart.dart';

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
            padding: const EdgeInsets.all(0),
            height: 80,
            width: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: Image.asset(
                    'assets/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  ' WHM',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                )
              ],
            )),
        const SizedBox(
          height: 15,
        ),
        search(),
        menu(
          title: 'Produits',
          index: 0,
          icon: Icons.view_quilt_rounded,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Categories',
          index: 1,
          icon: Icons.category_rounded,
        ),
        const SizedBox(height: 4),
        menu(
          title: 'Depots',
          index: 2,
          icon: Icons.warehouse_rounded,
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
          icon: Icons.dashboard_rounded,
        ),
        const Spacer(),
        profile(
          picture: context.read<UserProvider>().user[0].profile.toBytes(),
          name:
              "${context.read<UserProvider>().user[0].firstname} ${context.read<UserProvider>().user[0].lastname}",
        )
      ],
    );
  }

  Widget menu({icon, title, index}) {
    return InkWell(
      onTap: () {
        context.read<LayoutProvider>().setScreenIndex(index);
      },
      child: AnimatedContainer(
        alignment: Alignment.centerLeft,
        width: 200,
        height: 40,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.only(left: 10),
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          color: context.watch<LayoutProvider>().screenIndex == index
              ? Colors.orange[800]
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.read<LayoutProvider>().screenIndex == index
                  ? Colors.white
                  : Colors.grey,
            ),
            Container(
              height: 25,
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: context.read<LayoutProvider>().screenIndex == index
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
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
              onTap: () {
                logout();
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: picture == null
                    ? const Center(
                        child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 30,
                      ))
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
            Text(
              name!,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  logout() {
    context.read<UserProvider>().reset();
    context.read<ProductProvider>().reset(context: context);
    context.read<HistoryProvider>().setList();
    context.read<LayoutProvider>().setScreenIndex(0);
    AppConfig.preferences!.setBool("rememberMe", false);
  }

  Widget search() {
    return Container(
      height: 45,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 3.0, left: 5),
            child: Icon(
              Icons.search_rounded,
              size: 23,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              enabled: context.read<LayoutProvider>().screenIndex == 0,
              controller: StockToolBar.editingController,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: context.read<LayoutProvider>().screenIndex == 0
                    ? "Recherche"
                    : "Non disponible",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              onChanged: searchQuery(),
            ),
          ),
        ],
      ),
    );
  }

  searchQuery() {
    Timer? timer;

    void debounce(String q) {
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer(const Duration(milliseconds: 100), () async {
        await context.read<ProductProvider>().setList(
              context: context,
              filter: StockToolBar.editingController.text,
            );
      });
    }

    return debounce;
  }
}
