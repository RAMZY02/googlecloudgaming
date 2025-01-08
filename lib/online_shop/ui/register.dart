import 'dart:convert';
import 'package:flutter/material.dart';
import '../controller/customer_controller.dart';
import '../models/customer_register.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = CustomerController(); // Initialize CustomerController

  // Add ScrollController
  final ScrollController _scrollController = ScrollController();

  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _address = '';
  String _city = '';
  String _country = '';
  String _zipCode = '';
  String _errorMessage = '';

  @override
  void dispose() {
    // Dispose of the ScrollController when the widget is disposed.
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      setState(() {
        _errorMessage = '';
      });

      try {
        // Fetch all customers to check if the email is already used
        final customers = await _customerController.getAllCustomers();

        // Check if email is already used
        final emailExists = customers.any((customer) => customer.email == _email);

        if (emailExists) {
          setState(() {
            _errorMessage = 'Email already exists. Please use a different email.';
          });
          return;
        }

        // Create a new Customer object
        final newCustomer = Customer(
          name: _name,
          email: _email,
          password: _password,
          phoneNumber: _phoneNumber,
          address: _address,
          city: _city,
          country: _country,
          zipCode: _zipCode,
        );

        // Call API to register customer
        await _customerController.addCustomer(newCustomer);

        // Navigate to login page on success
        Navigator.pushReplacementNamed(context, '/loginPage');
      } catch (error) {
        // Handle errors (e.g., network issues)
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side: Image
          Expanded(
            flex: 5,
            child: Image.asset(
              'registerImage.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),

          // Right side: Form
          Expanded(
            flex: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Scrollbar(
                  controller: _scrollController, // Attach the ScrollController
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController, // Attach the ScrollController
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 116.0), // Add left margin
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.only(left: 116.0), // Add left margin
                          child: const Text(
                            'Daftar untuk membuat akun baru dan menikmati berbagai keuntungan.',
                            style: TextStyle(color: Colors.black54),
                          ),
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
                              _buildTextFormField('Full Name', (value) {
                                _name = value!.trim();
                              }),
                              const SizedBox(height: 16),
                              _buildTextFormField(
                                'Email',
                                    (value) {
                                  _email = value!.trim();
                                },
                                TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              _buildTextFormField(
                                'Password',
                                    (value) {
                                  _password = value!.trim();
                                },
                                TextInputType.text,
                                true,
                              ),
                              const SizedBox(height: 16),
                              _buildTextFormField(
                                'Telephone Number',
                                    (value) {
                                  _phoneNumber = value!.trim();
                                },
                                TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              _buildTextFormField('Address', (value) {
                                _address = value!.trim();
                              }),
                              const SizedBox(height: 16),
                              _buildTextFormField('City', (value) {
                                _city = value!.trim();
                              }),
                              const SizedBox(height: 16),
                              _buildTextFormField('Country', (value) {
                                _country = value!.trim();
                              }),
                              const SizedBox(height: 16),
                              _buildTextFormField(
                                'Postal Code',
                                    (value) {
                                  _zipCode = value!.trim();
                                },
                                TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 460,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _register,
                                  child: const Text('Register'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
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
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/loginPage');
                                    },
                                    child: const Text(
                                      'Login',
                                      style:
                                      TextStyle(color: Colors.blueAccent),
                                    ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      String label,
      void Function(String?) onSaved, [
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
        double width = 500, // Default to full width if no width is provided
      ]) {
    return Container(
      width: width, // Apply the specified width
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for better appearance
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          floatingLabelStyle: const TextStyle(color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan $label Anda';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

