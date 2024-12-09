import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final String? searchQuery;
  final Function(String) onSearchChanged;
  final Function() onToggleSearch;
  final Function() onCartPressed;
  final Function(String) onCategorySelected;

  const Navbar({
    Key? key,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.onCartPressed,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double calculateFontSize(double width) {
      if (width > 600) return 16; // Layar besar
      if (width > 400) return 14; // Layar sedang
      return 12; // Layar kecil
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logoSteppa.png',
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 40);
                },
              ),
              if (screenWidth > 300) ...[
                Row(
                  children: ['MEN', 'WOMEN', 'CHILD', 'BABY']
                      .map(
                        (category) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () => onCategorySelected(category),
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
              ]
            ],
          ),
          Row(
            children: [
              if (isSearching)
                Container(
                  width: screenWidth > 600
                      ? screenWidth * 0.2
                      : screenWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Cari sepatu...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              IconButton(
                onPressed: onToggleSearch,
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: onCartPressed,
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
