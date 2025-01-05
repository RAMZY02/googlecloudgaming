class Login {
  final String email;
  final String password;

  // Constructor
  Login({
    required this.email,
    required this.password,
  });

  // Convert Login to JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Create Login from JSON (for receiving from backend)
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
    );
  }
}
