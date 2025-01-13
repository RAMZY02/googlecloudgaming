class FactoryStock {
  final String productId;
  final String productName;
  final String productDescription;
  final String productCategory;
  final String productSize;
  final String productGender;
  final String productImage;
  final int stokQty;
  final double price;
  final String lastUpdate;

  FactoryStock({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productCategory,
    required this.productSize,
    required this.productGender,
    required this.productImage,
    required this.stokQty,
    required this.price,
    required this.lastUpdate,
  });

  // Factory method to create FactoryStock from JSON
  factory FactoryStock.fromJson(Map<String, dynamic> json) {
    return FactoryStock(
      productId: json['product_id'] ?? '', // Handle potential null value
      productName: json['product_name'] ?? '',
      productDescription: json['product_description'] ?? '',
      productCategory: json['product_category'] ?? '',
      productSize: json['product_size'] ?? '',
      productGender: json['product_gender'] ?? '',
      productImage: json['product_image'] ?? '', // Handle potential null value
      stokQty: json['stok_qty'] ?? 0, // Default to 0 if null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Ensure it's a double
      lastUpdate: json['last_update'] ?? '', // Handle potential null value
    );
  }

  // Method to convert FactoryStock to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_category': productCategory,
      'product_size': productSize,
      'product_gender': productGender,
      'product_image': productImage,
      'stok_qty': stokQty,
      'price': price,
      'last_update': lastUpdate,
    };
  }
}
