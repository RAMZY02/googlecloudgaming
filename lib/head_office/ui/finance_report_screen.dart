import 'package:flutter/material.dart';
import 'package:steppa/head_office/controller/head_office_controller.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HeadOfficeController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Reports'),
      ),
      body: ListView.builder(
        itemCount: controller.financeReports.length,
        itemBuilder: (context, index) {
          final report = controller.financeReports[index];
          return ListTile(
            title: Text(report.month),
            subtitle: Text(
                'Income: \$${report.income}, Expense: \$${report.expense}, Profit: \$${report.profit}'),
          );
        },
      ),
    );
  }
}