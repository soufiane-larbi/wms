import 'package:flutter/material.dart';
import 'package:whm/layout/app_bar.dart';

class LayoutProvider with ChangeNotifier {
  int _screen = 0;

  setScreenIndex(index) {
    _screen = index;
    StockToolBar.editingController.text = '';
    notifyListeners();
  }

  get screenIndex => _screen;
}
