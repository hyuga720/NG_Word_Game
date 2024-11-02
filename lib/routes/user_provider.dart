import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = 'anonymous';

  String get userId => _userId;

  void setUserId(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }
}
