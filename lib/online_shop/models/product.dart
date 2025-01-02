class Product {
  final String product_id;
  final String product_name;
  final String product_image;
  final String product_description;
  final String product_category;
  final String product_gender;
  final List<String> product_size;
  int stock_qty;
  int price;

  Product({
    required this.product_id,
    required this.product_name,
    required this.product_image,
    required this.product_description,
    required this.product_category,
    required this.product_gender,
    required this.product_size,
    this.stock_qty = 0,
    this.price = 0,
  });
}