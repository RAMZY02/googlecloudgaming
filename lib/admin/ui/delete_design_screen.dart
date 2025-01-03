import 'package:flutter/material.dart';
import 'package:steppa/admin/ui/manage_stock_screen.dart';
import '../models/shoe_stock.dart';

class DeleteDesignScreen extends StatefulWidget {
  const DeleteDesignScreen({Key? key}) : super(key: key);

  @override
  State<DeleteDesignScreen> createState() => _DeleteDesignScreenState();
}

class _DeleteDesignScreenState extends State<DeleteDesignScreen> {
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

  void _deleteDesign(String id) {
    setState(() {
      shoeStocks.removeWhere((stock) => stock.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Design'),
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
          return ListTile(
            title: Text(shoe.shoeName),
            leading: Image.network(shoe.imageUrl, width: 50, height: 50),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteDesign(shoe.id);
              },
            ),
          );
        },
      ),
    );
  }
}
