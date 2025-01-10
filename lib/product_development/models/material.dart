class MaterialModel {
  final String id;
  final String name;
  final int stok_qty;
  final String last_update;

  MaterialModel({required this.id, required this.name, required this.stok_qty, required this.last_update});

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'],
      stok_qty: json['stok_qty'],
      last_update: json['last_update'],
    );
  }
}
