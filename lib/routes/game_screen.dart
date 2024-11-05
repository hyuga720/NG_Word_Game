import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ゲーム画面'),
      ),
      body: Center(
        child: Text('ゲームが始まりました！'),
      ),
    );
  }
}
