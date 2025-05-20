import 'package:flutter/material.dart';
import 'package:food_delivery_app/service/widget_support.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage(
      {super.key,
      required this.image,
      required this.name,
      required this.price});
  final String image, name, price;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1, totalPrice = 0;

  @override
  void initState() {
    totalPrice = int.parse(widget.price);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(30)),
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                widget.image,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: AppWidget.headlineTextFieldStyle(),
            ),
            Text(
              widget.price,
              style: AppWidget.simpleTextFieldStyle(),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                  'Our classic cheese pizza is made with a hand-tossed crust, rich tomato basil sauce, and a blend of 100% mozzarella, provolone, and aged cheddar cheeses — melted to golden perfection. Finished with a touch of oregano for that perfect pizzeria flavor.'),
            ),
            SizedBox(height: 20),
            Text(
              'Quantity',
              style: AppWidget.simpleTextFieldStyle(),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    quantity = quantity + 1;
                    totalPrice = totalPrice + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  quantity.toString(),
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalPrice = totalPrice - int.parse(widget.price);

                        if (quantity == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Minimum quantity reached'),
                              backgroundColor: Color(0xffef2b39),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Minimum quantity reached'),
                            backgroundColor: Color(0xffef2b39),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    });
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        '\$${totalPrice.toString()}',
                        style: AppWidget.boldBhiteTextFieldStyle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Order Now',
                        style: AppWidget.whiteTextFieldStyle(),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {}
}
