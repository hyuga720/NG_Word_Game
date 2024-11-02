import 'package:flutter/material.dart';
import '../header.dart';
import 'lobby.dart'; // Lobby画面をインポート

class Home extends StatelessWidget {
  final String screenName = 'ホーム';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(screenName),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lobby()), // Lobby画面に遷移
                );
              },
              child: Text('Match Start'),
            ),
          ],
        ),
      ),
    );
  }
}
