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
      double baseFontSize = width * 0.02; // Hitung ukuran font berdasarkan lebar layar
      return baseFontSize > 16 ? 16 : baseFontSize; // Maksimal ukuran font adalah 16
    }

    double calculateTextBoxWidth(double width) {
      if (width > 600) {
        return width * 0.4; // Lebar untuk layar besar
      } else if (width > 400) {
        return width * 0.5; // Lebar untuk layar sedang
      } else {
        return width * 0.7; // Lebar untuk layar kecil
      }
    }

    double calculateTextBoxHeight(double width) {
      if (width > 600) {
        return 50; // Tinggi untuk layar besar
      } else if (width > 400) {
        return 45; // Tinggi untuk layar sedang
      } else {
        return 40; // Tinggi untuk layar kecil
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70, // Tinggi navbar standar
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logoSteppa.png',
                    height: screenWidth * 0.2 > 40 ? 40 : screenWidth * 0.2,
                    width: screenWidth * 0.2 > 40 ? 40 : screenWidth * 0.2,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.broken_image,
                        size: screenWidth * 0.2 > 40 ? 40 : screenWidth * 0.2,
                      );
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
                              style: TextStyle(
                                fontSize: calculateFontSize(screenWidth),
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
        ),
        // Kotak teks pencarian muncul di bawah navbar
        if (isSearching)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: calculateTextBoxWidth(screenWidth),
                  height: calculateTextBoxHeight(screenWidth),
                  child: TextField(
                    onChanged: onSearchChanged,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: calculateFontSize(screenWidth), // Ukuran font dinamis
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari sepatu...',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenWidth > 600 ? 12 : 8, // Padding vertikal menyesuaikan
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    final double baseHeight = 70; // Tinggi AppBar standar
    return Size.fromHeight(isSearching ? baseHeight + 60 : baseHeight);
  }
}
