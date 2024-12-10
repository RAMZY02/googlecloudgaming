class Customer {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
  });

  // Factory method untuk membuat instance Customer dari List
  factory Customer.fromList(List<dynamic> data) {
    return Customer(
      id: data[0] as String,
      name: data[1] as String,
      address: data[2] as String,
      city: data[3] as String,
      phone: data[4] as String,
    );
  }

  // Method untuk mengonversi objek Customer ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
    };
  }
}
