class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity; // Untuk menyimpan jumlah yang akan dibeli

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 0,
  });
}
