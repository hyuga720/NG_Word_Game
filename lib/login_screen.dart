import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 匿名ログインメソッド
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await _auth.signInAnonymously();
      Navigator.pushReplacementNamed(context, '/gameStart'); // ログイン後にGame Start画面に遷移
    } catch (e) {
      print('Failed to sign in anonymously: $e');
    }
  }

  // Googleログインメソッド
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // ログインがキャンセルされた場合

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/gameStart'); // ログイン後にGame Start画面に遷移
    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _signInAnonymously(context),
              child: Text('Sign in Anonymously'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

