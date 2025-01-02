import 'package:flutter/material.dart';
import '../models/customer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

List<Customer> dummyCustomers = [
  Customer(
    customerId: 'C001',
    name: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123', // Password pelanggan
    phoneNumber: '081234567890',
    address: 'Jl. Merdeka No. 1',
    city: 'Jakarta',
    country: 'Indonesia',
    zipCode: '10110',
  ),
  Customer(
    customerId: 'C002',
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'securePass', // Password pelanggan
    phoneNumber: '081298765432',
    address: 'Jl. Sudirman No. 2',
    city: 'Bandung',
    country: 'Indonesia',
    zipCode: '40291',
  ),
  // Tambahkan data pelanggan lainnya sesuai kebutuhan
];

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _login() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      // Reset error message before checking
      setState(() {
        _errorMessage = '';
      });

      // Cek apakah email ada di data dummy
      Customer? customer = dummyCustomers.firstWhere(
            (cust) => cust.email.toLowerCase() == _email.toLowerCase(),
      );

      if (customer == null) {
        setState(() {
          _errorMessage = 'Email tidak ditemukan.';
        });
      } else if (customer.password != _password) {
        setState(() {
          _errorMessage = 'Password salah.';
        });
      } else {
        // Login berhasil
        Navigator.pushReplacementNamed(context, '/homePage', arguments: customer);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red[100],
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Input Email
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan email Anda';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Input Password
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan password Anda';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}