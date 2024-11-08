import 'package:flutter/material.dart';
import '../header.dart';

class Settings extends StatelessWidget {
  final String screenName = '設定';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: Center(
        child: Text(screenName),
      ),
    );
  }
}