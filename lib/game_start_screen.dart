import 'package:flutter/material.dart';

class GameStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Start'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/chat'); // チャット画面に遷移
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}