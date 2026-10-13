import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مصروفاتي',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'مرحبا بكم في مصروفاتي',
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
