class ShoeStock {
  final String id;
  final String shoeName;
  final String imageUrl;
  Map<int, int> stock; // Key: Size, Value: Quantity

  ShoeStock({
    required this.id,
    required this.shoeName,
    required this.imageUrl,
    required this.stock,
  });
}
