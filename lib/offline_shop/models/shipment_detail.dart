class ShipmentDetail {
  final String shipmentDetailId;
  final String productId;
  final int quantity;
  final String productName;

  ShipmentDetail({
    required this.shipmentDetailId,
    required this.productId,
    required this.quantity,
    required this.productName,
  });

  factory ShipmentDetail.fromJson(Map<String, dynamic> json) {
    return ShipmentDetail(
      shipmentDetailId: json['shipment_detail_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      productName: json['product_name'],
    );
  }
}
