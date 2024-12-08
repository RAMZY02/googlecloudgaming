import 'package:flutter/material.dart';
import 'package:steppa/head_office/ui/employee_management_screen.dart';
import 'package:steppa/head_office/ui/finance_report_screen.dart';

class HeadOfficeDashboard extends StatelessWidget {
  const HeadOfficeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Head Office Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FinanceReportScreen()),
                );
              },
              child: const Text('View Finance Reports'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeeManagementScreen()),
                );
              },
              child: const Text('Manage Employees'),
            ),
          ],
        ),
      ),
    );
  }
}
