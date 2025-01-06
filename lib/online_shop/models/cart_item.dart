class cartItem {
  final String cartId;
  final String productId;
  final int quantity;
  final int price;

  cartItem({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  // Convert AddToCartRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
