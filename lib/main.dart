import 'package:flutter/material.dart';
import 'package:steppa/auth/ui/login_screen.dart';
import 'package:steppa/factory/ui/factory_attendance_screen.dart';
import 'package:steppa/factory/ui/factory_dashboard_screen.dart';
import 'package:steppa/factory/ui/factory_inventory_screen.dart';
import 'package:steppa/factory/ui/factory_materials_screen.dart';
import 'package:steppa/head_office/ui/head_office_dashboard_screen.dart';
import 'package:steppa/online_shop/ui/home.dart';
import 'package:steppa/oracle_data_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';


import 'online_shop/ui/detail_product.dart';
import 'online_shop/ui/search.dart';

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
      routes: <String, WidgetBuilder>{
        '/login': (context) => const LoginScreen(),
        '/factoryDashboard': (context) => const FactoryDashboard(),
        '/factoryAttendance': (context) => const FactoryAttendance(),
        '/factoryMaterials': (context) => const FactoryMaterials(),
        '/factoryInventory': (context) => const FactoryInventory(),
        '/headOfficeDashboard': (context) => const HeadOfficeDashboard(),
        '/homePage': (context) => const Home(),
        '/searchPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return Search(initialQuery: args); // Kirim args ke Search
        },
        '/detailProductPage': (context) => const DetailProduct(),
        '/oracleData': (context) => OracleDataScreen(),
        '/productDevelopmentDashboard': (context) => const ProductDevelopmentScreen(),
        '/pendingDesigns': (context) => const PendingDesignsScreen(),
        '/production': (context) => const ProductionScreen(),
      },
      home: const LoginScreen(),
    );
  }
}

