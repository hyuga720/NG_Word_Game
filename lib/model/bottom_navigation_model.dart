import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationModel extends ChangeNotifier {
  int _currentIndex = 2; // 最初に表示される画面

  // getter: 現在のインデックスを返す
  int get currentIndex => _currentIndex;

  // setter: インデックスを更新し、View側に通知する
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // View側に変更を通知
  }
}