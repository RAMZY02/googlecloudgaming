import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function() onToggleSearch;
  final Function() onCartPressed;

  const Navbar({
    Key? key,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.onCartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: isSearching
          ? TextField(
        onChanged: onSearchChanged,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Cari sepatu...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(color: Colors.black),
      )
          : Row(
        children: [
          // Logo Responsif
          Image.asset(
            'assets/logoSteppa.png',
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
          const SizedBox(width: 10),

          // Navigasi Kategori
          Row(
            children: ['MEN', 'WOMEN', 'CHILD', 'BABY']
                .map(
                  (category) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    print('$category dipilih');
                  },
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Colors.black,
          ),
          onPressed: onToggleSearch,
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: onCartPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
