import 'shipment_detail.dart';

class Shipment {
  final int shipmentId;
  final String shipmentDate;
  final String shipmentStatus;
  final List<ShipmentDetail> details;

  Shipment({
    required this.shipmentId,
    required this.shipmentDate,
    required this.shipmentStatus,
    required this.details,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      shipmentId: json['shipment_id'],
      shipmentDate: json['shipment_date'],
      shipmentStatus: json['shipment_status'],
      details: (json['details'] as List<dynamic>)
          .map((detail) => ShipmentDetail.fromJson(detail))
          .toList(),
    );
  }
}
