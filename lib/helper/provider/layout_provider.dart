import 'package:flutter/material.dart';

class LayoutProvider with ChangeNotifier {
  int _screen = 0;

  setScreenIndex(index) {
    _screen = index;
    notifyListeners();
  }

  get screenIndex => _screen;
}
