class UpdateCartItemRequest {
  final String cartItemId;
  final int quantity;

  UpdateCartItemRequest({required this.cartItemId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      "cart_item_id": cartItemId,
      "quantity": quantity,
    };
  }
}
