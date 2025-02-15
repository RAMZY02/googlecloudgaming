import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:steppa/admin/ui/delete_design_screen.dart';
import 'package:steppa/admin/ui/manage_stock_screen.dart';
import 'package:steppa/auth/ui/landing_page.dart';
import 'package:steppa/auth/ui/login_screen.dart';
import 'package:steppa/auth/ui/steppa_landing_page.dart';
import 'package:steppa/auth/ui/steppa_login.dart';
import 'package:steppa/factory/ui/factory_attendance_screen.dart';
import 'package:steppa/factory/ui/factory_dashboard_screen.dart';
import 'package:steppa/factory/ui/factory_inventory_screen.dart';
import 'package:steppa/factory/ui/factory_materials_screen.dart';
import 'package:steppa/firebase.dart';
import 'package:steppa/head_office/ui/head_office_dashboard_screen.dart';
import 'package:steppa/offline_shop/ui/factory_stock.dart';
import 'package:steppa/online_shop/ui/cart.dart';
import 'package:steppa/online_shop/ui/home.dart';
import 'package:steppa/online_shop/ui/order_history.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_progress_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/supplier/ui/add_supplier_screen.dart';
import 'package:steppa/supplier/ui/supplier_screen.dart';
import 'online_shop/ui/detail_product.dart';
import 'online_shop/ui/login.dart';
import 'online_shop/ui/register.dart';
import 'online_shop/ui/search.dart';
import 'offline_shop/ui/offline_shop_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/landing': (context) => const LandingPage(),
        '/steppa': (context) => const SteppaLandingPage(),
        '/loginPage': (context) => const Login(),
        '/loginSteppa': (context) => const SteppaLogin(),
        '/factoryDashboard': (context) => const FactoryDashboard(),
        '/factoryAttendance': (context) => const FactoryAttendance(),
        '/factoryMaterials': (context) => const FactoryMaterials(),
        '/factoryInventory': (context) => const FactoryInventory(),
        '/headOfficeDashboard': (context) => const HeadOfficeDashboard(),
        '/registerPage': (context) => const Register(),
        '/homePage': (context) => const Home(),
        '/searchPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return Search(initialQuery: args); // Kirim args ke Search
        },
        '/detailProductPage': (context) => const DetailProduct(),
        '/cartPage': (context) => const Cart(),
        '/orderHistoryPage': (context) => const OrderHistory(),
        '/productDevelopmentDashboard': (context) => const ProductDevelopmentScreen(),
        '/pendingDesigns': (context) => const PendingDesignsScreen(),
        '/production': (context) => const ProductionScreen(),
        '/production_progress': (context) => const ProductionProgressScreen(),
        '/designLists': (context) => const DesignListsScreen(),
        '/materialstorage': (context) => const MaterialsStorageScreen(),
        '/addSupplier': (context) => const MaterialsStorageScreen(),
        '/supplierList': (context) => const MaterialsStorageScreen(),
        '/offlineShop': (context) => const OfflineShopScreen(),
        '/manage-stock': (context) => const ManageStockScreen(),
        '/factory_stock': (context) => const FactoryStockScreen(),
        '/delete-design': (context) => const DeleteDesignScreen(),
        '/firebase': (context) => const AuthScreen(),
        '/supplier': (context) => const SupplierScreen(),
        '/add-supplier': (context) => const AddSupplierScreen(),
      },
      home: const LandingPage(),
    );
  }
}

