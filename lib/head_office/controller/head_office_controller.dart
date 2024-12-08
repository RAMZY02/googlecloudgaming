import '../models/employee.dart';
import '../models/finance_report.dart';

class HeadOfficeController {
  final List<Employee> employees = [
    Employee(id: '1', name: 'John Doe', position: 'Manager', salary: 7000),
    Employee(id: '2', name: 'Jane Smith', position: 'Accountant', salary: 5000),
  ];

  final List<FinanceReport> financeReports = [
    FinanceReport(month: 'January', income: 20000, expense: 15000),
    FinanceReport(month: 'February', income: 25000, expense: 18000),
  ];
}
