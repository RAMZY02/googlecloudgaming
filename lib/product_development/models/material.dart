class MaterialModel {
  final String material_id;
  final String material_name;
  final int stock_quantity;
  final String last_update;

  MaterialModel({required this.material_id, required this.material_name, required this.stock_quantity, required this.last_update});

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      material_id: json['material_id'],
      material_name: json['material_name'],
      stock_quantity: json['stock_quantity'],
      last_update: json['last_update'],
    );
  }
}
