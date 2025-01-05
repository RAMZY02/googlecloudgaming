class Product {
  String product_name;
  String product_category;
  String product_gender;
  int price;
  String product_image;

  Product({
    required this.product_name,
    required this.product_category,
    required this.product_gender,
    required this.price,
    required this.product_image,
  });

  // Mengubah JSON menjadi objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_name: json['product_name'] ?? '',
      product_category: json['product_category'] ?? '',
      product_gender: json['product_gender'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      product_image: json['product_image'] ?? '',
    );
  }

  // Mengubah objek Product menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'product_name': product_name,
      'product_category': product_category,
      'product_gender': product_gender,
      'price': price,
      'product_image': product_image,
    };
  }
}
