import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_screen.dart'; // ゲーム画面のインポート

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String lobbyId = 'defaultRoom'; // 固定のルームIDを使用

  @override
  void initState() {
    super.initState();
    _joinLobby();
  }

  // ロビーに参加してメンバーリストに自分を追加
  Future<void> _joinLobby() async {
    final lobbyRef = _firestore.collection('lobby').doc(lobbyId);

    // トランザクションでメンバー追加（重複を防ぐため）
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(lobbyRef);
      if (snapshot.exists) {
        List members = snapshot['members'] ?? [];
        if (!members.contains('myUserId')) {
          members.add('myUserId'); // 自分のユーザーIDを追加
          transaction.update(lobbyRef, {'members': members});
        }
      } else {
        transaction.set(lobbyRef, {'members': ['myUserId']});
      }
    });
  }

  // ロビーを離れる際にメンバーリストから自分を削除
  Future<void> _leaveLobby() async {
    final lobbyRef = _firestore.collection('lobby').doc(lobbyId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(lobbyRef);
      if (snapshot.exists) {
        List members = snapshot['members'] ?? [];
        members.remove('myUserId'); // 自分のユーザーIDを削除
        transaction.update(lobbyRef, {'members': members});
      }
    });
  }

  @override
  void dispose() {
    _leaveLobby();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ロビー'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('lobby').doc(lobbyId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List members = snapshot.data!['members'] ?? [];
          int memberCount = members.length;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ローディングインジケータを追加
              if (memberCount < 4)
                Column(
                  children: [
                    CircularProgressIndicator(), // 回転するローディングアニメーション
                    SizedBox(height: 10),
                    Text(
                      'マッチング中',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                )
              else
                Text(
                  'マッチ完了',
                  style: TextStyle(fontSize: 24),
                ),
              SizedBox(height: 20),
              Text(
                '$memberCount/4',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(4),
                    color: index < memberCount ? Colors.green : Colors.grey,
                  );
                }),
              ),
              if (memberCount >= 4)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen()),
                    );
                  },
                  child: Text('ゲーム開始'),
                ),
            ],
          );
        },
      ),
    );
  }
}

