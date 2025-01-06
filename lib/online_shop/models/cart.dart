class Cart {
  final String cartId;
  final String customerId;

  Cart({
    required this.cartId,
    required this.customerId,
  });

  // Convert JSON to Cart object
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
      customerId: json['customer_id'],
    );
  }
}
