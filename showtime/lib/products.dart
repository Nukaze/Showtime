class Product {
  late String name;
  late int price;
  late String imageUrl;

  Product(this.name, this.price, this.imageUrl);
}

List<Product> ProductList = [
  Product("Eat set Mpass", 150, "assets/images/popcorn_mpass.jpg"),
  Product("Barbie Popcorn", 450, "assets/images/popcorn_barbie.jpg"),
  Product("Lorem ipsom", 3000, ""),
  Product("Eiei za", 99, ""),
];
