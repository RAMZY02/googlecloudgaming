class Customer {
  final String customerId;
  final String name;
  final String password;
  final String email;
  final String phoneNumber;
  final String address;
  final String city;
  final String country;
  final String zipCode;

  Customer({
    required this.customerId,
    required this.name,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.country,
    required this.zipCode,
  });

  // Convert JSON to Customer object
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zip_code'],
    );
  }

  // Convert Customer object to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'password': password,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'zip_code': zipCode,
    };
  }
}
