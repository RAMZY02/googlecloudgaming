class Raw {
  final String material_id;
  final String material_name;
  final String stock_quantity;
  final String supplier_id;
  final DateTime last_update;

  Raw({
    required this.material_id,
    required this.material_name,
    required this.stock_quantity,
    required this.supplier_id,
    required this.last_update,

  });

  factory Raw.fromJson(Map<String, dynamic> json) {
    return Raw(
      material_id: json['material_id'],
      material_name: json['material_name'],
      stock_quantity: json['stock_quantity'],
      supplier_id: json['supplier_id'],
      last_update: json['last_update'],
    );
  }
}