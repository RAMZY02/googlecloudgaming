class Production {
  final int id;
  final int design_id;
  final String name;
  final int expected_qty;
  final int? actual_qty;
  final String status;
  final String production_size;

  Production({
    required this.id,
    required this.design_id,
    required this.name,
    required this.expected_qty,
    required this.actual_qty,
    required this.status,
    required this.production_size,
  });

  factory Production.fromJson(Map<String, dynamic> json) {
    return Production(
      id: json['id'],
      design_id: json['design_id'],
      name: json['name'],
      expected_qty: json['expected_qty'],
      actual_qty: json['actual_qty'],
      status: json['status'],
      production_size: json['production_size'],
    );
  }
}
