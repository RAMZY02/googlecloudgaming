class DeleteCartItem {
  final String cartItemId;

  DeleteCartItem({
    required this.cartItemId,
  });

  // Convert JSON to Cart object
  factory DeleteCartItem.fromJson(Map<String, dynamic> json) {
    return DeleteCartItem(
      cartItemId: json['cart_item_id'],
    );
  }
}
