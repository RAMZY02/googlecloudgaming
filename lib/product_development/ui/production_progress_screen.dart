import 'package:flutter/material.dart';
import 'package:steppa/product_development/controllers/production_controller.dart';
import 'package:steppa/product_development/models/production.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';

class ProductionProgressScreen extends StatefulWidget {
  const ProductionProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProductionProgressScreen> createState() => _ProductionProgressScreenState();
}

class _ProductionProgressScreenState extends State<ProductionProgressScreen> {
  final ProductionController _productionController = ProductionController();
  List<Production> ongoingProductions = [];

  @override
  void initState() {
    super.initState();
    _fetchOngoingProductions();
  }

  Future<void> _fetchOngoingProductions() async {
    try {
      final resData = await _productionController.fetchAllOngoingProductions();
      setState(() {
        ongoingProductions = resData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch ongoing productions: $e')),
      );
    }
  }

  Future<void> _markAsDone(int id, int actualQuantity) async {
    try {
      await _productionController.markAsDone(id, actualQuantity);
      await _fetchOngoingProductions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Production marked as done!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as done: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Progress'),
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
                'Product Research & Development',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Workspace'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDevelopmentScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending Designs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingDesignsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Design Lists'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DesignListsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('Production Planner'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('Production Progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionProgressScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Raw Materials Storage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialsStorageScreen(),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: ongoingProductions.length,
          itemBuilder: (context, index) {
            final production = ongoingProductions[index];
            final TextEditingController _quantityController = TextEditingController();
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${production.name}   Size - ${production.production_size}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          production.status,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Expected Quantity: ${production.expected_qty}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Actual Quantity',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          onPressed: () {
                            if (_quantityController.text.isNotEmpty) {
                              final actualQuantity = int.parse(_quantityController.text);
                              if(actualQuantity > production.expected_qty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Actual quantity cannot be more than expected quantity')),
                                );
                              }
                              else if(actualQuantity < 0){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Actual quantity cannot be less than 0')),
                                );
                              }
                              else{
                                _markAsDone(production.id, actualQuantity);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter actual quantity.')),
                              );
                            }
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
