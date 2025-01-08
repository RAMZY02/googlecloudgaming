class CustomerDetails {
  final String customerId;
  final String email;
  final String phone;

  CustomerDetails({
    required this.customerId,
    required this.email,
    required this.phone,
  });

  // Factory method untuk membuat objek CustomerDetails dari JSON map
  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      customerId: json['customer_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  // Method untuk mengonversi objek CustomerDetails ke JSON map
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'email': email,
      'phone': phone,
    };
  }
}
