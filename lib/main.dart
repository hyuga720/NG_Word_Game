import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ng_word_game/model/bottom_navigation_model.dart';
import 'package:ng_word_game/routes/chat.dart';
import 'routes/profile.dart';
import 'routes/home.dart';
import 'routes/settings.dart';
import 'login_screen.dart';
import 'routes/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List _pageList = [
    Profile(),
    Home(),
    Chat(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Flutterの練習',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: AuthWrapper(pageList: _pageList),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final List pageList;

  AuthWrapper({required this.pageList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return ChangeNotifierProvider<BottomNavigationModel>(
            create: (_) => BottomNavigationModel(),
            child: Consumer<BottomNavigationModel>(
              builder: (context, model, child) {
                return Scaffold(
                  body: pageList[model.currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'プロフィール',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'ホーム',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.chat),
                        label: 'チャット',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: '設定',
                      ),
                    ],
                    currentIndex: model.currentIndex,
                    onTap: (index) {
                      model.currentIndex = index;
                    },
                    selectedItemColor: Colors.pinkAccent,
                    unselectedItemColor: Colors.black45,
                  ),
                );
              },
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

