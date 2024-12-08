// import 'package:flutter/material.dart';
//
// // Simulasi role pengguna setelah login (dapat diganti dengan query API)
// enum UserRole { admin, factory, management }
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String _errorMessage = '';
//
//   // Fungsi login yang akan mengecek kredensial pengguna
//   Future<void> _login() async {
//     // Simulasi loading
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     // Simulasi cek kredensial (gantilah dengan autentikasi dari API)
//     await Future.delayed(Duration(seconds: 2)); // Simulasi request API
//
//     if (_usernameController.text == 'user' && _passwordController.text == 'password') {
//       // Ganti ini dengan query atau verifikasi role pengguna dari API
//       UserRole role = UserRole.factory;  // Misalnya role yang berhasil login adalah factory
//
//       // Arahkan berdasarkan role pengguna
//       if (role == UserRole.admin) {
//         Navigator.pushReplacementNamed(context, '/admin-dashboard');
//       } else if (role == UserRole.factory) {
//         Navigator.pushReplacementNamed(context, '/factory-dashboard');
//       } else if (role == UserRole.management) {
//         Navigator.pushReplacementNamed(context, '/management-dashboard');
//       }
//     } else {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Username atau password salah';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _login,
//               child: _isLoading ? CircularProgressIndicator() : Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/factoryDashboard');
              },
              child: Text('Factory'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/headOfficeDashboard');
              },
              child: Text('Head Office'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/productDevelopmentDashboard');
              },
              child: Text('Product Development'),
            ),
          ],
        ),
      ),
    );
  }
}
