import 'package:flutter/material.dart';
import 'package:steppa/auth/ui/login_screen.dart';
import 'package:steppa/factory/ui/factory_attendance_screen.dart';
import 'package:steppa/factory/ui/factory_dashboard_screen.dart';
import 'package:steppa/factory/ui/factory_inventory_screen.dart';
import 'package:steppa/factory/ui/factory_materials_screen.dart';
import 'package:steppa/head_office/ui/head_office_dashboard_screen.dart';

import 'online_shop/ui/home.dart';

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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/factoryDashboard': (context) => const FactoryDashboard(),
        '/factoryAttendance': (context) => const FactoryAttendance(),
        '/factoryMaterials': (context) => const FactoryMaterials(),
        '/factoryInventory': (context) => const FactoryInventory(),
        '/headOfficeDashboard': (context) => const HeadOfficeDashboard(),
      },
      home: const LoginScreen(),
    );
  }
}

