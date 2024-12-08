import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:steppa/factory/ui/widgets/factory_drawer.dart';
// import 'package:fl_chart/fl_chart.dart';

class FactoryDashboard extends StatelessWidget {
  const FactoryDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factory Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: const FactoryDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'DStatus Produksi: Aktif', //aktif, downtime, maintenance
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children:[
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: _buildInfoCard('Schedule', 'Steppa sports f2'),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: _buildInfoCard('Currently', 'On Track'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                      // const SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _buildChartCard('Stok Produk Ready Sale', _buildBarChart()),
                      //     _buildChartCard('Total Setoran Harian', _buildLineChart()),
                      //   ],
                      // ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: _buildInfoCard('Produksi Bulan Ini', '90 Kotak/Pcs')
                        ),
                        Container(
                          width: double.infinity,
                          child: _buildInfoCard('Jumlah Produk Cacat', '7 Kotak/Pcs')
                        ),
                        Container(
                          width: double.infinity,
                          child: _buildInfoCard('Waktu Siklus Produksi', '3h 06m')
                        ),
                        Container(
                          width: double.infinity,
                          child: _buildInfoCard('Barang Stok Menipis', 'Karet')
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card untuk tombol
  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Card untuk grafik
  Widget _buildChartCard(String title, Widget chart) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(height: 200, child: chart),
            ],
          ),
        ),
      ),
    );
  }

  // Grafik batang
  // Widget _buildBarChart() {
  //   return BarChart(
  //     BarChartData(
  //       borderData: FlBorderData(show: false),
  //       barGroups: [
  //         BarChartGroupData(x: 1, barRods: [
  //           BarChartRodData(toY: 10, color: Colors.blue),
  //         ]),
  //         BarChartGroupData(x: 2, barRods: [
  //           BarChartRodData(toY: 15, color: Colors.blue),
  //         ]),
  //         BarChartGroupData(x: 3, barRods: [
  //           BarChartRodData(toY: 7, color: Colors.blue),
  //         ]),
  //       ],
  //     ),
  //   );
  // }
  //
  // // Grafik garis
  // Widget _buildLineChart() {
  //   return LineChart(
  //     LineChartData(
  //       borderData: FlBorderData(show: false),
  //       lineBarsData: [
  //         LineChartBarData(
  //           isCurved: true,
  //           spots: [
  //             const FlSpot(0, 100),
  //             const FlSpot(1, 90),
  //             const FlSpot(2, 80),
  //             const FlSpot(3, 60),
  //             const FlSpot(4, 30),
  //           ],
  //           belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Card untuk informasi
  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.blue, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
