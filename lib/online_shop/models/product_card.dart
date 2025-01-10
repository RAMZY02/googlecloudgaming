class Product_Cart {
  final String? product_name;
  final String? product_description;
  final String? product_category;
  final String? product_gender;
  final int? price;
  String? product_image;

  Product_Cart({
    required this.product_name,
    required this.product_description,
    required this.product_category,
    required this.product_gender,
    required this.price,
    required this.product_image,
  });

  // Constructor untuk salinan
  Product_Cart copyWith({
    String? product_name,
    String? product_description,
    String? product_category,
    String? product_gender,
    int? price,
    String? product_image,
  }) {
    return Product_Cart(
      product_name: product_name ?? this.product_name,
      product_description: product_description ?? this.product_description,
      product_category: product_category ?? this.product_category,
      product_gender: product_gender ?? this.product_gender,
      price: price ?? this.price,
      product_image: product_image ?? this.product_image,
    );
  }

  // Konstruktor untuk mengonversi JSON menjadi objek Product
  factory Product_Cart.fromJson(Map<String, dynamic> json) {
    return Product_Cart(
      product_name: json['product_name'],
      product_description: json['product_description'],
      product_category: json['product_category'],
      product_gender: json['product_gender'],
      price: json['price'],
      product_image: json['product_image'],
    );
  }
}
