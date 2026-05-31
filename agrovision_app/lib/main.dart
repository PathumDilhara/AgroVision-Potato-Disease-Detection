import 'package:flutter/material.dart';

import 'features/disease_detection/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Potato leafs disease detection",
      home: HomeScreen(),
    );
  }
}
