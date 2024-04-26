import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showtime/products.dart';
import 'package:showtime/qr_scanner.dart';
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
  }

  int _selectedIndex = 2;

  int _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }

  static List<String> prefactureList = [
    'Bangkok',
    'Pathum Tani',
    'Chiang Mai',
    'Phuket',
    'Pattaya'
  ];
  static Map<String, List<String>> majorCineplexBranches = {
    'Bangkok': [
      'Central World',
      'Siam Paragon',
      'Central Rama 9',
      'Central Pinklao',
      'Rachayothin',
      'Central Ladprao',
      'Central Bangna'
    ],
    'Pathum Tani': ['Future Park Rangsit', 'Major Rangsit'],
    'Chiang Mai': ['Central Festival Chiang Mai', 'Maya Chiang Mai'],
    'Phuket': ['Central Festival Phuket', 'Jungceylon'],
    'Pattaya': ['Central Festival Pattaya', 'Harbor Mall Pattaya']
  };
  static List<String> eatList = ['Popcorn', 'Food', 'Drink', 'Snack'];

  String selectedPrefecture = prefactureList[0];
  String selectedBranch = majorCineplexBranches[prefactureList[0]]![0];
  String selectedEat = eatList[0];

  Widget _buildDropdown(
    double _width,
    double _height,
    List<dynamic> contentList,
    String selectedItem,
    Function(String?) onDropdownChanged,
  ) {
    List<String> stringList =
        contentList.map((element) => element.toString()).toList();

    return Column(
      children: <Widget>[
        SizedBox(
          width: _width * .8, // Set width
          height: _height * .9, // Set height
          child: DropdownButton<String>(
            dropdownColor: Colors.black.withOpacity(.9),
            value: selectedItem,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black12,
            ),
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            items: stringList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: onDropdownChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    List<Product> productList = ProductList;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        crossAxisSpacing: 16.0, // Spacing between columns
        mainAxisSpacing: 16.0, // Spacing between rows
      ),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final prod = productList[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.black.withOpacity(0.5),
            child: InkWell(
              onTap: () {
                alertDialog(context, "Shopping",
                    "You selected ${productList[index].name}\n${prod.price} baht");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: (prod.imageUrl.isEmpty)
                        ? const SizedBox(
                            height: 80,
                          )
                        : Image.asset(
                            prod.imageUrl,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prod.name,
                          style: const TextStyle(
                            color: Colors.yellow,
                          ),
                        ),
                        Text(
                          "Price: ${prod.price} baht",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 20,
                  left: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black.withOpacity(0.5),
                      width: 50,
                      height: 50,
                      child: BackButton(
                        color: Colors.white,
                        onPressed: () {
                          // Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const QrScanner(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return child; // No transition animation
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black.withOpacity(0.5),
                      width: 280,
                      height: 50,
                      child: _buildDropdown(
                        280,
                        50,
                        prefactureList,
                        selectedPrefecture,
                        (String? newValue) {
                          setState(() {
                            selectedPrefecture = newValue!;
                            selectedBranch =
                                majorCineplexBranches[newValue]![0];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black.withOpacity(0.5),
                      width: 350,
                      height: 50,
                      child: _buildDropdown(
                        350,
                        50,
                        majorCineplexBranches[selectedPrefecture]!,
                        selectedBranch,
                        (String? newValue) {
                          setState(() {
                            selectedBranch = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: const Rect.fromLTWH(10, 150, 370, 570),
                  child: _buildProductList(),
                ),
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
