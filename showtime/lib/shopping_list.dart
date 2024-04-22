import 'package:flutter/material.dart';
import 'package:showtime/products.dart';
import 'package:showtime/utils.dart';

import 'custom_navbar.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      alertDialog(context, "Shopping", "product list = $productList");
    });
  }

  int _selectedIndex = 2;
  int _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }

  List<Product> productList = ProductList;

  Widget _buildProductList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final prod = productList[index];
        return Container(
          width: 50,
          height: 150,
          child: Card(
            color: Colors.white.withOpacity(0.5),
            child: ListTile(
              leading:
                  (prod.imageUrl.isEmpty) ? null : Image.asset(prod.imageUrl),
              title: Text(prod.name),
              subtitle: Text("Price: ${prod.price} baht"),
              selectedColor: Colors.red,
              selectedTileColor: Colors.greenAccent.withOpacity(0.5),
              contentPadding: const EdgeInsets.all(12),
              minLeadingWidth: 0,
              onTap: () {
                alertDialog(context, "Shopping",
                    "You selected ${productList[index].name}\n${prod.price} baht");
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/showtime_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildProductList(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          initialIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
