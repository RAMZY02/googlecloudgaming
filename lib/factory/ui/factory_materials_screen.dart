import 'package:flutter/material.dart';
import 'package:steppa/factory/ui/widgets/factory_drawer.dart';

class FactoryMaterials extends StatelessWidget {
  const FactoryMaterials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Bahan Baku'),
        backgroundColor: Colors.blue,
      ),
      drawer: const FactoryDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildStockCard(
              'Tepung',
              '500 kg',
              'Persediaan mencukupi untuk 7 hari produksi.',
              Colors.green,
            ),
            _buildStockCard(
              'Gula',
              '200 kg',
              'Stok menipis! Perlu pemesanan ulang.',
              Colors.red,
            ),
            _buildStockCard(
              'Mentega',
              '300 kg',
              'Persediaan mencukupi untuk 14 hari produksi.',
              Colors.green,
            ),
            _buildStockCard(
              'Telur',
              '100 kotak',
              'Cukup untuk 3 hari produksi.',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(String item, String quantity, String status, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.inventory,
              size: 40,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
