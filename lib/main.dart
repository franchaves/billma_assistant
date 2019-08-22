import 'package:flutter/material.dart';
import 'screens/ChatScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BillMa Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(title: 'BillMa ChatBot!'),
    );
  }
}
