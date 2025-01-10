class Staff {
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? address;
  final String? city;
  final String? country;
  final String? zipCode;

  Staff({
    required this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.address,
    this.city,
    this.country,
    this.zipCode,
  });

  // Convert JSON to Staff object
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zip_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'address': address,
      'city': city,
      'country': country,
      'zip_code': zipCode,
    };
  }
}
