class MaterialModel {
  final int id;
  final String name;

  MaterialModel({required this.id, required this.name});

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
