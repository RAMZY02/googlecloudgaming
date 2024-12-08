import 'package:flutter/material.dart';
import 'package:steppa/factory/ui/factory_dashboard_screen.dart';
import 'package:steppa/head_office/ui/head_office_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FactoryDashboard(),
    );
  }
}

