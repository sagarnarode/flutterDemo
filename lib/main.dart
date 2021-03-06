import 'package:flutter/material.dart';
import 'package:fluttter_demo/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.green,
        primaryColor: Colors.green,
        accentColor: Colors.blue,
        buttonColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home:Home(),
    );
  }
}
Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }