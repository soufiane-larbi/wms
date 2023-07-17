import 'package:flutter/material.dart';
import 'package:whm/layout/app_bar.dart';

class LayoutProvider with ChangeNotifier {
  int _screen = 0;
  bool _showPrint = false;
  get isPrintDisplayed => _showPrint;
  get screenName {
    if (_screen == 0) return "Produits";
    if (_screen == 1) return "Categories";
    if (_screen == 2) return "Depots";
    if (_screen == 3) return "Historique";
    if (_screen == 4) return "Tableau De Bord";
  }

  showPrint() {
    _showPrint = true;
    notifyListeners();
  }

  hidePrint() {
    _showPrint = false;
    notifyListeners();
  }

  setScreenIndex(index) {
    _screen = index;
    StockToolBar.editingController.text = '';
    notifyListeners();
  }

  get screenIndex => _screen;
}
