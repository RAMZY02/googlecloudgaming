import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ProductDevelopmentScreen extends StatefulWidget {
  const ProductDevelopmentScreen({Key? key}) : super(key: key);

  @override
  State<ProductDevelopmentScreen> createState() => _ProductDevelopmentScreenState();
}

class _ProductDevelopmentScreenState extends State<ProductDevelopmentScreen> {
  Uint8List? _selectedImageBytes;
  String? _imageLink;
  String? _shoeName;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = imageBytes;
      });
    }
  }

  void _setImageFromLink() {
    if (_imageLink != null && _imageLink!.isNotEmpty) {
      setState(() {
        _selectedImageBytes = null; // Reset any previously selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Upload'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Upload'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductDevelopmentScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending Designs'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/pendingDesigns');
              },
            ),
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('Production Planning'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/production');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Back To Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Shoe Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _shoeName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Image Link (Google Drive)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _imageLink = value;
                });
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 450,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    _selectedImageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
                    : (_imageLink != null && _imageLink!.isNotEmpty)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _imageLink!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Failed to load image'),
                      );
                    },
                  ),
                )
                    : const Center(
                  child: Text(
                    'Tap to upload image or use link',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if ((_selectedImageBytes != null || (_imageLink != null && _imageLink!.isNotEmpty)) &&
                    _shoeName != null &&
                    _shoeName!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Design "$_shoeName" Uploaded Successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete all fields!')),
                  );
                }
              },
              child: const Text('Submit Design'),
            ),
          ],
        ),
      ),
    );
  }
}
