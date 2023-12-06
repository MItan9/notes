

import 'package:flutter/material.dart';
import 'package:notes/pages/auth_page.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(

  ),
  home: AuthPage(),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Мое приложение Flutter'),
        ),
        body: Center(
          child: Container(
            child: Image.asset('assets\launcher/icon.png'),
          ),
        ),
      ),
    );
  }
}








