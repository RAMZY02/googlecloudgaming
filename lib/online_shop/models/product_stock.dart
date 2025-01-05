class Product_Stock {
  final int stokQty;

  Product_Stock({required this.stokQty});

  factory Product_Stock.fromJson(Map<String, dynamic> json) {
    return Product_Stock(
      stokQty: json['stok_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stok_qty': stokQty,
    };
  }
}
