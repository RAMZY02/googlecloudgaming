import 'package:flutter/material.dart';

class SteppaLandingPage extends StatelessWidget {
  const SteppaLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/productDevelopmentDashboard');
                },
                child: Text('RND'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/offlineShop');
                },
                child: Text('Cashier'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/supplier');
                },
                child: Text('Materials Storage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
