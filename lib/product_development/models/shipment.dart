import 'shipment_detail.dart';

class Shipment {
  final String shipment_id;
  final String shipment_date;
  final String shipment_status;

  Shipment({
    required this.shipment_id,
    required this.shipment_date,
    required this.shipment_status,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      shipment_id: json['shipment_id'],
      shipment_date: json['shipment_date'],
      shipment_status: json['shipment_status'],
    );
  }
}
