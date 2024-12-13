import 'package:flutter/material.dart';
import 'package:steppa/head_office/ui/dashboard_card.dart';
import 'package:steppa/head_office/ui/employee_management_screen.dart';
import 'package:steppa/head_office/ui/finance_report_screen.dart';
import 'package:steppa/head_office/ui/production_report_screen.dart';
import 'package:steppa/head_office/ui/selling_report_screen.dart';

// import 'about_screen.dart';

class HeadOfficeDashboard extends StatelessWidget {
  const HeadOfficeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Head Office Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Jumlah kolom
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            DashboardCard(
              icon: Icons.bar_chart,
              title: 'Finance Reports',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinanceReportScreen(),
                  ),
                );
              },
            ),
            DashboardCard(
              icon: Icons.people,
              title: 'Manage Employees',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployeeManagementScreen(),
                  ),
                );
              },
            ),
            DashboardCard(
              icon: Icons.factory, // Menggunakan ikon yang relevan untuk produksi
              title: 'Production Reports',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductionReportsScreen()),
                );
              },
            ),
            DashboardCard(
              icon: Icons.attach_money, // Ikon relevan untuk penjualan
              title: 'Selling Reports',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SellingReportsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}