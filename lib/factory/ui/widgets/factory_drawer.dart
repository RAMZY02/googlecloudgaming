import 'package:flutter/material.dart';

class FactoryDrawer extends StatelessWidget {
  const FactoryDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Manufacturer',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/factoryDashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text('Stok Bahan Baku'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/factoryMaterials');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stok Barang Jadi'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/factoryInventory');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Absensi'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/factoryAttendance');
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/settings');
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
