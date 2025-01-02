import 'package:flutter/material.dart';
import 'navbar.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isSearching = false;
  String? searchQuery;

  final List<Map<String, dynamic>> itemOnCart = [
    {
      'name': 'Nike Roshe Run',
      'price': 900000,
      'image': 'assets/nike.jpg',
      'colors': 'Black',
      'size': '38',
      'gender': 'FEMALE',
      'qty': 1,
    },
    {
      'name': 'Reebok Rush',
      'price': 560000,
      'image': 'assets/reebok.jpg',
      'colors': 'Brown',
      'size': '44',
      'gender': 'MALE',
      'qty': 2,
    },
    {
      'name': 'Adidas Fury',
      'price': 770000,
      'image': 'assets/adidas.jpeg',
      'colors': 'Blue',
      'size': '38',
      'gender': 'MALE',
      'qty': 1,
    },
    {
      'name': 'Adidas Neo Racer',
      'price': 700000,
      'image': 'assets/neo.jpg',
      'colors': 'Gray',
      'size': '33',
      'gender': 'FEMALE',
      'qty': 3,
    },
    {
      'name': 'Adidas AX2 Full Black',
      'price': 800000,
      'image': 'assets/ax2.jpg',
      'colors': 'Black',
      'size': '36',
      'gender': 'MALE',
      'qty': 4,
    },
    {
      'name': 'Adidas Zoom',
      'price': 500000,
      'image': 'assets/zoom.jpeg',
      'colors': 'Blue',
      'size': '32',
      'gender': 'FEMALE',
      'qty': 2,
    },
  ];

  void _navigateToSearch() {
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/searchPage',
        arguments: searchQuery,
      );
    }
  }

  /*int calculateTotal() {
    return itemOnCart.fold(
      0,
          (sum, item) {
        final rawPrice = item['price'];
        final price = int.tryParse(rawPrice.replaceAll('.', '')) ?? 0;
        final qty = item['qty'] as int;

        print('Item: ${item['name']}, Price: $rawPrice, Qty: $qty, Parsed Price: $price');
        return sum + (price * qty);
      },
    );
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        isSearching: isSearching,
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        onSearchSubmitted: (value) {
          setState(() {
            searchQuery = value;
          });
          _navigateToSearch();
        },
        onToggleSearch: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: itemOnCart.map((item) {
                  final subtotal = item['price'] * item['qty'];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            item['image'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Warna: ${item['colors']}'),
                                Text('Ukuran: ${item['size']}'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Jumlah:'),
                                    DropdownButton<int>(
                                      value: item['qty'],
                                      items: List.generate(10, (index) => index + 1)
                                          .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text('$value'),
                                      ))
                                          .toList(),
                                      onChanged: (newQty) {
                                        setState(() {
                                          item['qty'] = newQty;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp${subtotal.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER SUMMARY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      /*Text(
                        'Rp${calculateTotal().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                      ),*/
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('VAT included:'),
                      Text('Rp0'),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ORDER TOTAL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      /*Text(
                        'Rp${calculateTotal().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
