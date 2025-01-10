class Transaction {
  final String saleId;
  final int total;

  Transaction({required this.saleId, required this.total});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      saleId: json['saleId'],
      total: (json['total']),
    );
  }
}
