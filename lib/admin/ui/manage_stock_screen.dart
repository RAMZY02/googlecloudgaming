import 'package:flutter/material.dart';
import 'package:steppa/admin/ui/delete_design_screen.dart';
import '../models/shoe_stock.dart';

class ManageStockScreen extends StatefulWidget {
  const ManageStockScreen({Key? key}) : super(key: key);

  @override
  State<ManageStockScreen> createState() => _ManageStockScreenState();
}

class _ManageStockScreenState extends State<ManageStockScreen> {
  final List<ShoeStock> shoeStocks = [
    ShoeStock(
      id: '1',
      shoeName: 'Sporty Max',
      imageUrl: 'https://via.placeholder.com/150',
      stock: {40: 10, 41: 8, 42: 12, 43: 5},
    ),
    ShoeStock(
      id: '2',
      shoeName: 'Casual Flex',
      imageUrl: 'https://via.placeholder.com/150',
      stock: {40: 7, 41: 9, 42: 11, 43: 6},
    ),
  ];

  void _updateStock(String id, int size, int quantity) {
    setState(() {
      final shoe = shoeStocks.firstWhere((stock) => stock.id == id);
      shoe.stock[size] = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stock'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Master Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Manage Stock'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageStockScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Design'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteDesignScreen(),
                  ),
                );
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
      body: ListView.builder(
        itemCount: shoeStocks.length,
        itemBuilder: (context, index) {
          final shoe = shoeStocks[index];
          return Card(
            child: ExpansionTile(
              title: Text(shoe.shoeName),
              subtitle: Text('Stock Details'),
              leading: Image.network(shoe.imageUrl, width: 50, height: 50),
              children: shoe.stock.entries.map((entry) {
                return ListTile(
                  title: Text('Size: ${entry.key}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value.toString(),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
                              _updateStock(shoe.id, entry.key, int.tryParse(value) ?? 0);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('pcs'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
