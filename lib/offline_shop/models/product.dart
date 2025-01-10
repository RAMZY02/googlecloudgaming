class Product {
  final String? product_name;
  final String? product_description;
  final String? product_category;
  final String? product_gender;
  final int? price;
  final String? product_image;
  final String? product_id;
  final String? product_size;
  final int? product_quantity;

  Product({
    required this.product_name,
    required this.product_description,
    required this.product_category,
    required this.product_gender,
    required this.price,
    required this.product_image,
    required this.product_id,
    required this.product_size,
    required this.product_quantity,
  });

  // Konstruktor untuk mengonversi JSON menjadi objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_name: json['product_name'],
      product_description: json['product_description'],
      product_category: json['product_category'],
      product_gender: json['product_gender'],
      price: json['price'],
      product_image: json['product_image'],
      product_id: json['product_id'],
      product_size: json['product_size'],
      product_quantity: json['product_quantity'],
    );
  }
}

