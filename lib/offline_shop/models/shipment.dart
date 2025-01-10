import 'shipment_detail.dart';

class Shipment {
  final String shipmentId;
  final String shipmentDate;
  final String shipmentStatus;

  Shipment({
    required this.shipmentId,
    required this.shipmentDate,
    required this.shipmentStatus,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      shipmentId: json['shipment_id'],
      shipmentDate: json['shipment_date'],
      shipmentStatus: json['shipment_status'],
    );
  }
}
