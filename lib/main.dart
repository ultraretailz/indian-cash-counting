import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CashCountingApp());
}

class CashCountingApp extends StatelessWidget {
  const CashCountingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Cash Counting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
