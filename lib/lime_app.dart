import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'form.dart';

class LimeCalculationApp extends StatelessWidget {
  const LimeCalculationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lime Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const LimeDataForm(),
    );
  }
}
