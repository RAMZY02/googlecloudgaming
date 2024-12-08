import 'package:flutter/material.dart';
import 'package:steppa/factory/ui/widgets/factory_drawer.dart';

class FactoryAttendance extends StatelessWidget {
  const FactoryAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absen Karyawan"),
        backgroundColor: Colors.blue,
      ),
      drawer: const FactoryDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PIC: John Doe",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tanggal: ${DateTime.now().toLocal()}".split(' ')[0],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Daftar Kehadiran
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Ganti sesuai jumlah karyawan
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text("Karyawan ${index + 1}"),
                      subtitle: const Text("Status: Hadir"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika untuk ubah status
                        },
                        child: const Text("Ubah Status"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FactoryAttendance(),
  ));
}
