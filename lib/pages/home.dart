import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/burger_model.dart';
import 'package:food_delivery_app/model/category_model.dart';
import 'package:food_delivery_app/model/chinese_model.dart';
import 'package:food_delivery_app/model/mexican_model.dart';
import 'package:food_delivery_app/model/pizza_model.dart';
import 'package:food_delivery_app/pages/bottom_nav.dart';
import 'package:food_delivery_app/pages/details_page.dart';
import 'package:food_delivery_app/service/burger_data.dart';
import 'package:food_delivery_app/service/category_data.dart';
import 'package:food_delivery_app/service/chinese_data.dart';
import 'package:food_delivery_app/service/database.dart';
import 'package:food_delivery_app/service/mexican_data.dart';
import 'package:food_delivery_app/service/pizza_data.dart';
import 'package:food_delivery_app/service/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizzas = [];
  List<BurgerModel> burgers = [];
  List<ChineseModel> chinese = [];
  List<MexicanModel> mexican = [];
  String track = "0";
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearchLoading = false;

  // Search functionality
  void onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults = [];
        isSearchLoading = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      isSearchLoading = true;
    });

    try {
      // Search using the searchByName method
      QuerySnapshot querySnapshot = await DataBaseMethods().searchByName(value);

      List<Map<String, dynamic>> results = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        results.add(data);
      }

      setState(() {
        searchResults = results;
        isSearchLoading = false;
      });
    } catch (e) {
      print("Search error: $e");
      setState(() {
        searchResults = [];
        isSearchLoading = false;
      });
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      searchResults = [];
      isSearchLoading = false;
    });
  }

  @override
  void initState() {
    categories = getCategories();
    pizzas = getPizza();
    burgers = getBurger();
    chinese = getChinese();
    mexican = getMexican();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 40),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 50,
                      width: 110,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Order Your Favourite Food!',
                      style: AppWidget.simpleTextFieldStyle(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'images/boy.jpg',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),

            // Search Bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for food...',
                        suffixIcon:
                            isSearching
                                ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: clearSearch,
                                )
                                : null,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.search, color: Colors.white, size: 30),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Main Content
            Expanded(
              child:
                  isSearching ? _buildSearchResults() : _buildCategoryContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Search Results Widget
  Widget _buildSearchResults() {
    if (isSearchLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xffef2b39)));
    }

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No food items found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.only(right: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 5.0,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var item = searchResults[index];
        // Handle price properly - convert to string without decimals if needed
        String priceValue;
        if (item['price'] != null) {
          if (item['price'] is num) {
            // If it's a number, format it properly
            double price = item['price'].toDouble();
            priceValue =
                price % 1 == 0 ? price.toInt().toString() : price.toString();
          } else {
            priceValue = item['price'].toString();
          }
        } else {
          priceValue = '0';
        }

        return SearchResultTile(
          item['name'] ?? 'Unknown',
          item['image'] ?? '',
          priceValue,
        );
      },
    );
  }

  // Category Content Widget
  Widget _buildCategoryContent() {
    return Column(
      children: [
        // Categories
        Container(
          height: 70,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryTile(
                categories[index].name!,
                categories[index].image!,
                index.toString(),
              );
            },
          ),
        ),
        SizedBox(height: 10),

        // Food Items based on category
        track == "0"
            ? Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: pizzas.length,
                itemBuilder: (context, index) {
                  return FoodTile(
                    pizzas[index].name!,
                    pizzas[index].image!,
                    pizzas[index].price!,
                  );
                },
              ),
            )
            : track == "1"
            ? Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: burgers.length,
                itemBuilder: (context, index) {
                  return FoodTile(
                    burgers[index].name!,
                    burgers[index].image!,
                    burgers[index].price!,
                  );
                },
              ),
            )
            : track == "2"
            ? Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: chinese.length,
                itemBuilder: (context, index) {
                  return FoodTile(
                    chinese[index].name!,
                    chinese[index].image!,
                    chinese[index].price!,
                  );
                },
              ),
            )
            : track == "3"
            ? Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: mexican.length,
                itemBuilder: (context, index) {
                  return FoodTile(
                    mexican[index].name!,
                    mexican[index].image!,
                    mexican[index].price!,
                  );
                },
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }

  // Search Result Tile Widget
  Widget SearchResultTile(String name, String image, String price) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 150,
              width: 150,
              child:
                  image.startsWith('http')
                      ? Image.network(
                        image,
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      )
                      : Image.asset(
                        image,
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              name,
              style: AppWidget.boldTextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("\$$price", style: AppWidget.simpleTextFieldStyle()),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            DetailsPage(image: image, name: name, price: price),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  color: Color(0xffef2b39),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Food Tile Widget (for category display)
  Widget FoodTile(String name, String image, String price) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(name, style: AppWidget.boldTextStyle()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("\$$price", style: AppWidget.simpleTextFieldStyle()),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            DetailsPage(image: image, name: name, price: price),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  color: Color(0xffef2b39),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category Tile Widget
  Widget CategoryTile(String name, String image, String categoryIndex) {
    return GestureDetector(
      onTap: () {
        // Clear search when switching categories
        if (isSearching) {
          clearSearch();
        }
        track = categoryIndex.toString();
        setState(() {
          print('track count $track');
        });
      },
      child:
          track == categoryIndex
              ? Container(
                margin: EdgeInsets.only(right: 20, bottom: 10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 3.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Image.asset(image, height: 40, width: 40),
                        SizedBox(width: 10),
                        Text(name, style: AppWidget.whiteTextFieldStyle()),
                      ],
                    ),
                  ),
                ),
              )
              : Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset(image, height: 40, width: 40),
                    SizedBox(width: 10),
                    Text(name, style: AppWidget.simpleTextFieldStyle()),
                  ],
                ),
              ),
    );
  }
}
