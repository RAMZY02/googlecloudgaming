class CartItem {
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

  CartItem({
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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cart_item_id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      productCategory: json['product_category'],
      productSize: json['product_size'],
      productGender: json['product_gender'],
      productImage: json['product_image'],
      stockQty: json['stok_qty'],
      productPrice: (json['product_price'] as num).toDouble(),
    );
  }

  // Method copyWith untuk membuat salinan dengan perubahan nilai tertentu
  CartItem copyWith({
    String? cartItemId,
    String? cartId,
    String? productId,
    int? quantity,
    double? price,
    String? status,
    String? productName,
    String? productDescription,
    String? productCategory,
    String? productSize,
    String? productGender,
    String? productImage,
    int? stockQty,
    double? productPrice,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      status: status ?? this.status,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productCategory: productCategory ?? this.productCategory,
      productSize: productSize ?? this.productSize,
      productGender: productGender ?? this.productGender,
      productImage: productImage ?? this.productImage,
      stockQty: stockQty ?? this.stockQty,
      productPrice: productPrice ?? this.productPrice,
    );
  }
}
