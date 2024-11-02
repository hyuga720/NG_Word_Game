import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart'; // UserProviderをインポート

class Profile extends StatelessWidget {
  final String screenName = 'プロフィール';
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('現在のユーザーID: ${userProvider.userId}'),
            SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: '新しいユーザーIDを入力',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('IDを変更'),
              onPressed: () {
                final newUserId = _idController.text;
                if (newUserId.isNotEmpty) {
                  // UserProviderでIDを更新
                  final oldUserId = userProvider.userId;
                  userProvider.setUserId(newUserId);

                  // Firestore内の全メッセージをバッチ処理で更新
                  _updateMessagesUserId(oldUserId, newUserId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Firestore内のメッセージのuserIdをバッチ処理で更新
  void _updateMessagesUserId(String oldUserId, String newUserId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc('defaultRoom')
        .collection('messages')
        .where('userId', isEqualTo: oldUserId) // 古いuserIdでフィルタ
        .get();

    // 取得したすべてのメッセージを新しいuserIdで更新
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {
        'userId': newUserId, // userIdを新しいものに更新
      });
    }

    // 一括更新を実行
    await batch.commit();
  }
}