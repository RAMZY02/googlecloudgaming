class Product {
  String product_Name;
  String product_Category;
  String product_Gender;
  String price;
  String product_Image;

  Product({
    required this.product_Name,
    required this.product_Category,
    required this.product_Gender,
    required this.price,
    required this.product_Image,
  });

  // Mengubah JSON menjadi objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_Name: json['product_name'] ?? '',
      product_Category: json['product_category'] ?? '',
      product_Gender: json['product_gender'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      product_Image: json['product_image'] ?? '',
    );
  }

  // Mengubah objek Product menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'product_name': product_Name,
      'product_category': product_Category,
      'product_gender': product_Gender,
      'price': price,
      'product_image': product_Image,
    };
  }
}
