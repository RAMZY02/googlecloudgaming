import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final List<String> availableDesigns = [
    "Classic Sneaker",
    "Running Shoe",
    "High-top Boot",
    "Casual Loafer",
    "Sport Sandal",
  ];

  String? selectedDesign;
  DateTime? selectedDate;
  int quantity = 1;

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materials = {
      "Leather": 1,
      "Lace": 1,
      "Rubber (grams)": 200,
      "Fabric": 1,
    };

    final calculatedMaterials = materials.map((key, value) =>
        MapEntry(key, (value * quantity).toString() + (key == "Rubber (grams)" ? "g" : " pcs")));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Planning"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 1: Choose a Design",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedDesign,
              hint: const Text("Select a design"),
              isExpanded: true,
              items: availableDesigns.map((design) {
                return DropdownMenuItem(
                  value: design,
                  child: Text(design),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDesign = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              "Step 2: Select Production Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text("Pick a Date"),
                ),
                const SizedBox(width: 10),
                if (selectedDate != null)
                  Text(selectedDate != null ? DateFormat.yMMMd().format(selectedDate!) : 'Select a date'),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Step 3: Set Quantity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                    });
                  }
                      : null,
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Materials Needed:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...calculatedMaterials.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("${entry.key}: ${entry.value}"),
              );
            }).toList(),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDesign = null;
                      selectedDate = null;
                      quantity = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedDesign != null && selectedDate != null
                      ? () {
                    _showSuccessSnackBar("Production planning created successfully!");
                  }
                      : null,
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
