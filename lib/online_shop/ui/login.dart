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
    password: 'password123',
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
    password: 'securePass',
    phoneNumber: '081298765432',
    address: 'Jl. Sudirman No. 2',
    city: 'Bandung',
    country: 'Indonesia',
    zipCode: '40291',
  ),
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

      setState(() {
        _errorMessage = '';
      });

      // Check if email exists
      Customer? customer = dummyCustomers.firstWhereOrNull(
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
        // Successful login
        Navigator.pushReplacementNamed(context, '/homePage', arguments: customer);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MASUK',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jadilah member - Anda akan mendapatkan diskon 20% untuk pembelian pertama Anda. Dapatkan penawaran, undangan, dan hadiah eksklusif.',
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
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
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {},
                            ),
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/registerPage');
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
