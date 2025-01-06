import 'package:flutter/material.dart';
import 'dart:typed_data';

class ProductDevelopmentScreen extends StatefulWidget {
  const ProductDevelopmentScreen({Key? key}) : super(key: key);

  @override
  State<ProductDevelopmentScreen> createState() => _ProductDevelopmentScreenState();
}

class _ProductDevelopmentScreenState extends State<ProductDevelopmentScreen> {
  String? _imageLink;
  String? _shoeName;
  String? _selectedCategory;
  String? _selectedGender;
  String? _selectedSoleMaterial;
  String? _selectedBodyMaterial;
  String? _price;

  final List<String> _categories = ['Casual', 'Running', 'Training'];
  final List<String> _genders = ['Male', 'Female'];
  final List<String> _soleMaterials = ['Karet', 'Foam', 'Plastik'];
  final List<String> _bodyMaterials = ['Kain', 'Kulit', 'Kulit Sintesis'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Workspace'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Product Research & Development',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Workspace'),
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
        child: SingleChildScrollView(
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: _selectedGender,
                items: _genders
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Price (Rp)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sole Material',
                  border: OutlineInputBorder(),
                ),
                value: _selectedSoleMaterial,
                items: _soleMaterials
                    .map((material) => DropdownMenuItem(
                  value: material,
                  child: Text(material),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSoleMaterial = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Body Material',
                  border: OutlineInputBorder(),
                ),
                value: _selectedBodyMaterial,
                items: _bodyMaterials
                    .map((material) => DropdownMenuItem(
                  value: material,
                  child: Text(material),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBodyMaterial = value;
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
              Container(
                height: 750,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: (_imageLink != null && _imageLink!.isNotEmpty)
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
                    'Image will be displayed here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if ((_imageLink != null && _imageLink!.isNotEmpty) &&
                      _shoeName != null &&
                      _shoeName!.isNotEmpty &&
                      _selectedCategory != null &&
                      _selectedGender != null &&
                      _price != null &&
                      _selectedSoleMaterial != null &&
                      _selectedBodyMaterial != null) {
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
      ),
    );
  }
}
