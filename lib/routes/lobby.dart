import 'package:flutter/material.dart';
import '../header.dart';

class Lobby extends StatelessWidget {
  final String screenName = 'ロビー';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 戻るボタンで前の画面に戻る
          },
        ),
      ),
      body: Center(
        child: Text(screenName),
      ),
    );
  }
}
