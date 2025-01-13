class History {
  final String saleId;
  final String saleChannel;
  final DateTime saleDate;
  final double total;

  History({
    required this.saleId,
    required this.saleChannel,
    required this.saleDate,
    required this.total,
  });

  // Factory constructor untuk mengubah JSON menjadi objek Sale
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      saleId: json['sale_id'],
      saleChannel: json['sale_channel'],
      saleDate: DateTime.parse(json['sale_date']),
      total: json['total'].toDouble(),
    );
  }

  // Method untuk mengubah objek Sale menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'sale_id': saleId,
      'sale_channel': saleChannel,
      'sale_date': saleDate.toIso8601String(),
      'total': total,
    };
  }
}
