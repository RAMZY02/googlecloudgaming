import 'package:flutter/material.dart';
import 'package:steppa/factory/ui/widgets/factory_drawer.dart';

class FactoryInventory extends StatefulWidget {
  const FactoryInventory({Key? key}) : super(key: key);

  @override
  _FactoryInventoryState createState() => _FactoryInventoryState();
}

class _FactoryInventoryState extends State<FactoryInventory> {
  // Dummy data untuk stok barang jadi
  List<Product> _products = [
    Product(name: 'Produk A', quantity: 250, urgency: 'Low'),
    Product(name: 'Produk B', quantity: 50, urgency: 'High'),
    Product(name: 'Produk C', quantity: 120, urgency: 'Low'),
    Product(name: 'Produk D', quantity: 30, urgency: 'Medium'),
  ];

  // Pilihan filter dan sorting
  String _sortBy = 'Name';
  String _urgencyFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Sorting dan filtering data
    List<Product> filteredProducts = _products.where((product) {
      if (_urgencyFilter == 'All') return true;
      return product.urgency == _urgencyFilter;
    }).toList();

    // Sorting produk berdasarkan nama atau urgensi
    if (_sortBy == 'Name') {
      filteredProducts.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Urgency') {
      filteredProducts.sort((a, b) => a.urgency.compareTo(b.urgency));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Barang Jadi'),
        backgroundColor: Colors.blue,
      ),
      drawer: const FactoryDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter berdasarkan nama atau urgensi
                DropdownButton<String>(
                  value: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 'Name', child: Text('Sort by Name')),
                    DropdownMenuItem(value: 'Urgency', child: Text('Sort by Urgency')),
                  ],
                ),
                // Filter berdasarkan urgensi
                DropdownButton<String>(
                  value: _urgencyFilter,
                  onChanged: (value) {
                    setState(() {
                      _urgencyFilter = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 'All', child: Text('All Urgency')),
                    DropdownMenuItem(value: 'High', child: Text('High Urgency')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium Urgency')),
                    DropdownMenuItem(value: 'Low', child: Text('Low Urgency')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildStockCard(filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(Product product) {
    Color urgencyColor = Colors.green;
    if (product.urgency == 'Medium') {
      urgencyColor = Colors.orange;
    } else if (product.urgency == 'High') {
      urgencyColor = Colors.red;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.inventory_2, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.quantity} unit',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Urgency: ${product.urgency}',
                  style: TextStyle(
                    fontSize: 14,
                    color: urgencyColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final int quantity;
  final String urgency;

  Product({
    required this.name,
    required this.quantity,
    required this.urgency,
  });
}
