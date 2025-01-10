class Supplier {
  final String supplier_id;
  final String name;
  final String location;
  final String contact_info;

  Supplier({
    required this.supplier_id,
    required this.name,
    required this.location,
    required this.contact_info,

  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplier_id: json['supplier_id'],
      name: json['name'],
      location: json['location'],
      contact_info: json['contact_info'],
    );
  }
}