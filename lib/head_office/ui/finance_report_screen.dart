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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: controller.financeReports.length,
          itemBuilder: (context, index) {
            final report = controller.financeReports[index];
            final profitColor = report.profit >= 0 ? Colors.green : Colors.red;
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.month,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Income: \$${report.income.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'Expense: \$${report.expense.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profit:',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          '\$${report.profit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: profitColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
