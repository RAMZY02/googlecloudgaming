import 'package:flutter/material.dart';
import '../controller/customer_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final Customer_Controller customerController = Customer_Controller(); // Initialize Customer_Controller

  String _email = '';
  String _password = '';
  String _errorMessage = '';

  // Function to login
  void _login() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      setState(() {
        _errorMessage = '';
      });

      try {
        // Call the loginUser function from the controller
        final result = await customerController.loginUser(_email, _password);

        // Check the result message (login success or failure)
        if (result == "Login successful.") {
          // If login is successful, navigate to home page
          Navigator.pushReplacementNamed(context, '/homePage');
        } else {
          setState(() {
            _errorMessage = result; // If any error, display the error message
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'An error occurred: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side with image
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('loginImage.jpg'), // Path gambar Anda
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Right side with form
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Anda akan mendapatkan diskon 20% untuk pembelian pertama Anda. Dapatkan penawaran, undangan, dan hadiah eksklusif.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
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
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
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
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.visibility),
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              _password = value!.trim();
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
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
                                "Don't have an account?",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/registerPage');
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.lightBlueAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}