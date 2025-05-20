import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/burger_model.dart';
import 'package:food_delivery_app/model/category_model.dart';
import 'package:food_delivery_app/model/pizza_model.dart';
import 'package:food_delivery_app/pages/bottom_nav.dart';
import 'package:food_delivery_app/pages/details_page.dart';
import 'package:food_delivery_app/service/burger_data.dart';
import 'package:food_delivery_app/service/category_data.dart';
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
  String track = "0";

  @override
  void initState() {
    categories = getCategories();
    pizzas = getPizza();
    burgers = getBurger();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 40),
        child: Column(
          children: [
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
                )
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Color(0xFFececf8),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Search...'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
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
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            track == "0"
                ? Expanded(
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 5.0),
                        itemCount: pizzas.length,
                        itemBuilder: (context, index) {
                          return FoodTile(pizzas[index].name!,
                              pizzas[index].image!, pizzas[index].price!);
                        }),
                  )
                : track == "1"
                    ? Expanded(
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.6,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 5.0),
                            itemCount: burgers.length,
                            itemBuilder: (context, index) {
                              return FoodTile(burgers[index].name!,
                                  burgers[index].image!, burgers[index].price!);
                            }),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(20)),
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
            child: Text(
              name,
              style: AppWidget.boldTextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "\$$price",
              style: AppWidget.simpleTextFieldStyle(),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsPage(
                              image: image,
                              name: name,
                              price: price,
                            )));
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget CategoryTile(String name, String image, String categoryIndex) {
    return GestureDetector(
        onTap: () {
          track = categoryIndex.toString();
          setState(() {
            print('track count $track');
          });
        },
        child: track == categoryIndex
            ? Container(
                margin: EdgeInsets.only(right: 20, bottom: 10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 3.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Image.asset(
                          image,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          name,
                          style: AppWidget.whiteTextFieldStyle(),
                        )
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
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Image.asset(
                      image,
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      name,
                      style: AppWidget.simpleTextFieldStyle(),
                    )
                  ],
                ),
              ));
  }
}
