class Design {
  final int id;
  final String name;
  final String image;
  final String description;
  final String category;
  final String gender;
  final String soleMaterial;
  final String bodyMaterial;

  Design({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.gender,
    required this.soleMaterial,
    required this.bodyMaterial,
  });

  factory Design.fromJson(Map<String, dynamic> json) {
    return Design(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      gender: json['gender'],
      soleMaterial: json['soleMaterial'],
      bodyMaterial: json['bodyMaterial'],
    );
  }
}