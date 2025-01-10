class Product_Stock {
  final int stokQty;
  final String productId;

  Product_Stock({required this.stokQty, required this.productId});

  factory Product_Stock.fromJson(Map<String, dynamic> json) {
    return Product_Stock(
      stokQty: json['stok_qty'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stok_qty': stokQty,
      'product_id': productId,
    };
  }
}
