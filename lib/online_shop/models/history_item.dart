class HistoryItem {
  final String cartItemId;
  final String cartId;
  final String productId;
  final int quantity;
  final double price;
  final String status;
  final String productName;
  final String productDescription;
  final String productCategory;
  final String productSize;
  final String productGender;
  final String productImage;
  final int stockQty;
  final double productPrice;

  HistoryItem({
    required this.cartItemId,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.status,
    required this.productName,
    required this.productDescription,
    required this.productCategory,
    required this.productSize,
    required this.productGender,
    required this.productImage,
    required this.stockQty,
    required this.productPrice,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      cartItemId: json['cart_item_id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      status: json['status'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      productCategory: json['product_category'],
      productSize: json['product_size'],
      productGender: json['product_gender'],
      productImage: json['product_image'],
      stockQty: json['stok_qty'],
      productPrice: json['product_price'].toDouble(),
    );
  }
}
