class Product_Cart {
  final String? product_name;
  final String? product_description;
  final String? product_category;
  final String? product_gender;
  final int? price;
  final String? product_image;

  Product_Cart({
    required this.product_name,
    required this.product_description,
    required this.product_category,
    required this.product_gender,
    required this.price,
    required this.product_image,
  });

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
