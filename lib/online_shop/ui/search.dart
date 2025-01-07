import 'package:flutter/material.dart';
import '../models/product_card.dart';
import '../controller/product_controller.dart'; // Import controller untuk fetch data
import 'navbar.dart';

class Search extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const Search({Key? key, this.initialQuery, this.initialCategory})
      : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ProductController productController = ProductController();
  List<Product_Cart> allProducts = [];
  List<Product_Cart> filteredProducts = [];
  bool isLoading = true;

  String? searchQuery;
  String? selectedGender;
  String? selectedCategory;
  String? sortBy;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is String) {
      if (arguments.contains("Sport") || arguments.contains("Casual") || arguments.contains("Running")) {
        selectedCategory = arguments;
        searchQuery = null;
      } else {
        searchQuery = arguments;
        selectedCategory = null;
      }
    }
  }

  Future<void> fetchProducts() async {
    try {
      List<Product_Cart> products = await productController.getAllProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
      // Terapkan filter berdasarkan category jika ada
      if (selectedCategory != null && selectedCategory!.isNotEmpty) {
        applyFiltersAndSort();
      } else if (searchQuery != null && searchQuery!.isNotEmpty) {
        performSearch(searchQuery!);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query.trim();
      applyFiltersAndSort();
    });
  }

  void applyFiltersAndSort() {
    List<Product_Cart> tempProducts = allProducts;

    if (selectedGender != null && selectedGender!.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => product.product_gender == selectedGender)
          .toList();
    }

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => product.product_category == selectedCategory)
          .toList();
    }

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        final name = product.product_name!.toLowerCase();
        final query = searchQuery!.toLowerCase();
        return name.contains(query);
      }).toList();
    }

    if (sortBy == "name") {
      tempProducts.sort((a, b) => a.product_name!.compareTo(b.product_name!));
    } else if (sortBy == "price") {
      tempProducts.sort((a, b) => a.price!.compareTo(b.price!));
    }

    setState(() {
      filteredProducts = tempProducts;
    });
  }

  void clearFilter(String filterType) {
    setState(() {
      if (filterType == "gender") {
        selectedGender = null;
      } else if (filterType == "category") {
        selectedCategory = null;
      } else if (filterType == "sort") {
        sortBy = null;
      }
      applyFiltersAndSort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        isSearching: true,
        onSearchChanged: (value) {},
        onToggleSearch: () {
          setState(() {
            searchQuery = '';
            applyFiltersAndSort();
          });
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage');
        },
        onLogoPressed: () {
          Navigator.pushNamed(context, '/homePage');
        },
        onSearchSubmitted: performSearch,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Gender Dropdown
                  DropdownButton<String>(
                    value: selectedGender,
                    hint: const Text("Gender"),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    items: ["Male", "Female", "Unisex"]
                        .map((gender) => DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList()
                      ..insert(
                          0,
                          const DropdownMenuItem<String>(
                              value: "", child: Text("Clear Filter"))),
                    onChanged: (value) {
                      setState(() {
                        selectedGender =
                        value == "" ? null : value;
                        applyFiltersAndSort();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 8),
                  // Category Dropdown
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("Category"),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    items: ["Casual", "Running", "Sport"]
                        .map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    ))
                        .toList()
                      ..insert(
                          0,
                          const DropdownMenuItem<String>(
                              value: "", child: Text("Clear Filter"))),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory =
                        value == "" ? null : value;
                        applyFiltersAndSort();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 8),
                  // Sort Dropdown
                  DropdownButton<String>(
                    value: sortBy,
                    hint: const Text("Sort"),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    items: ["name", "price"]
                        .map((sort) => DropdownMenuItem<String>(
                      value: sort,
                      child: Text("Sort by $sort"),
                    ))
                        .toList()
                      ..insert(
                          0,
                          const DropdownMenuItem<String>(
                              value: "", child: Text("Clear Sort"))),
                    onChanged: (value) {
                      setState(() {
                        sortBy = value == "" ? null : value;
                        applyFiltersAndSort();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    'Tidak ada produk yang ditemukan.',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : GridView.builder(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detailProductPage',
                      arguments: product,
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              product.product_image!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                      Icons.broken_image,
                                      size: 40),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.product_name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${product.price}",
                                style: const TextStyle(
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

