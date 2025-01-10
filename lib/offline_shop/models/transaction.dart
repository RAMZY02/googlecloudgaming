class Transaction {
  final String saleId;
  final int total;
  final String saleChannel;
  final List<String> products;
  final List<int> quantities;
  final List<int> prices;

  Transaction({
    required this.saleId,
    required this.total,
    required this.saleChannel,
    required this.products,
    required this.quantities,
    required this.prices,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      saleId: json['saleId'], // ID transaksi dari backend
      total: json['total'], // Total harga dari backend
      saleChannel: json['sale_channel'], // Saluran penjualan
      products: List<String>.from(json['products']), // Daftar produk
      quantities: List<int>.from(json['quantities']), // Kuantitas per produk
      prices: List<int>.from(json['prices']), // Harga per produk
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sale_channel': saleChannel, // Saluran penjualan
      'products': products, // Daftar produk
      'quantities': quantities, // Kuantitas per produk
      'prices': prices, // Harga per produk
    };
  }
}
