import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://via.placeholder.com/400x200.png?text=About+Us', // Ganti dengan URL gambar nyata
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'About Our Company',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur '
                    'vulputate, mauris id consequat posuere, metus est eleifend tortor, '
                    'at ultrices risus justo nec neque. Phasellus sed lacus elit. Ut sit '
                    'amet eros eu lectus feugiat cursus nec eget justo. Integer congue '
                    'fermentum magna a facilisis.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
