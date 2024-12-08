class FinanceReport {
  final String month;
  final double income;
  final double expense;

  FinanceReport({
    required this.month,
    required this.income,
    required this.expense,
  });

  double get profit => income - expense;
}
