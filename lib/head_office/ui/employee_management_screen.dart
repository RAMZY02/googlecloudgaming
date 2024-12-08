import 'package:flutter/material.dart';
import 'package:steppa/head_office/controller/head_office_controller.dart';

class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HeadOfficeController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
      ),
      body: ListView.builder(
        itemCount: controller.employees.length,
        itemBuilder: (context, index) {
          final employee = controller.employees[index];
          return ListTile(
            title: Text(employee.name),
            subtitle: Text('${employee.position} - \$${employee.salary}'),
          );
        },
      ),
    );
  }
}
