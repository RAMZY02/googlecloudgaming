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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: controller.employees.length,
          itemBuilder: (context, index) {
            final employee = controller.employees[index];
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
                      employee.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Position: ${employee.position}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Salary: \$${employee.salary.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Edit employee functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Edit ${employee.name}')),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Warna latar belakang tombol
                            foregroundColor: Colors.white, // Warna teks menjadi putih
                          ),
                          onPressed: () {
                            // Delete employee functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Delete ${employee.name}')),
                            );
                          },
                          child: const Text('Delete'),
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

