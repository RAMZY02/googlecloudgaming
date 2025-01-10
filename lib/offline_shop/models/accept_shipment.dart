class AcceptShipment {
  final String? shipmentId;

  AcceptShipment({required this.shipmentId});

  Map<String, dynamic> toJson() {
    return {
      "shipmentId": shipmentId,
    };
  }
}