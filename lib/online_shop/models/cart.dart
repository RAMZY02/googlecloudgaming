class Cart {
  final String cartId;

  Cart({
    required this.cartId,
  });

  // Convert JSON to Cart object
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
    );
  }
}
