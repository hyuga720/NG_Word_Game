import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart'; // UserProviderをインポート

class Chat extends StatelessWidget {
  final String screenName = 'チャット';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<UserProvider>(context).userId; // 現在のユーザーIDを取得

    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc('defaultRoom')
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    String messageUserId = message['userId']; // FirestoreのuserIdを表示

                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text('User: $messageUserId'),
                      onLongPress: messageUserId == currentUserId
                          ? () {
                        _deleteMessage(context, message.id);
                      }
                          : null, // 他のユーザーのメッセージは削除できない
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'メッセージを入力',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(currentUserId); // メッセージ送信時にユーザーIDを使用
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String userId) {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chatRooms').doc('defaultRoom').collection('messages').add({
        'message': _controller.text,
        'userId': userId, // userIdをFireStoreに保存
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }

  void _deleteMessage(BuildContext context, String messageId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('メッセージを削除しますか？'),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('削除'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed) {
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc('defaultRoom')
          .collection('messages')
          .doc(messageId)
          .delete();
    }
  }
}