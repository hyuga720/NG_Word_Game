import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // AuthWrapperが定義されているmain.dartをインポート

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String headerTitle;

  // コンストラクタで必須パラメータとしてheaderTitleを受け取る
  Header({super.key, required this.headerTitle});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(headerTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Firebaseからサインアウト
              await FirebaseAuth.instance.signOut();

              // ログイン画面に戻り、ナビゲーションスタックをリセット
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()), // AuthWrapperが含まれているMyAppに戻す
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}
