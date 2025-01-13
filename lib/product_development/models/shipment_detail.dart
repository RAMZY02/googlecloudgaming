class ShipmentDetail {
  final String shipment_detail_id;
  final String material_id;
  final int quantity;
  final String material_name;

  ShipmentDetail({
    required this.shipment_detail_id,
    required this.material_id,
    required this.quantity,
    required this.material_name,
  });

  factory ShipmentDetail.fromJson(Map<String, dynamic> json) {
    return ShipmentDetail(
      shipment_detail_id: json['shipment_detail_id'],
      material_id: json['material_id'],
      quantity: json['quantity'],
      material_name: json['material_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipment_detail_id': shipment_detail_id,
      'material_id': material_id,
      'quantity': quantity,
      'material_name': material_name,
    };
  }
}
