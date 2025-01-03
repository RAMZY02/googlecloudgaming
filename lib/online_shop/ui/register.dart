import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _address = '';
  String _city = '';
  String _country = '';
  String _zipCode = '';
  String _errorMessage = '';

  void _register() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        _errorMessage = '';
      });
      Navigator.pushReplacementNamed(context, '/loginPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/registerBg.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Daftar untuk membuat akun baru dan menikmati berbagai keuntungan.',
                            style: TextStyle(color: Colors.white),
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
                                _buildTextFormField('Email', (value) {
                                  _email = value!.trim();
                                }, TextInputType.emailAddress),
                                const SizedBox(height: 16),
                                _buildTextFormField('Password', (value) {
                                  _password = value!.trim();
                                }),
                                const SizedBox(height: 16),
                                _buildTextFormField('Telephone Number', (value) {
                                  _phoneNumber = value!.trim();
                                }, TextInputType.phone),
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
                                _buildTextFormField('Postal Code', (value) {
                                  _zipCode = value!.trim();
                                }, TextInputType.number),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/loginPage');
                                      },
                                      child: const Text(
                                          'Login',
                                          style: TextStyle(color: Colors.blueAccent),
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
      ]) {
    return TextFormField(
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
    );
  }
}
