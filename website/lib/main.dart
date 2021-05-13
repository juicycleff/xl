import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(TheWave());

class TheWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'XL: 🌊 The Wave',
        color: Colors.black,
        theme: ThemeData(fontFamily: 'Quicksand'),
        home: const HomePage(),
      );
}
