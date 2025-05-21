import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/service/constant.dart';
import 'package:food_delivery_app/service/database.dart';
import 'package:food_delivery_app/service/shared_pref.dart';
import 'package:food_delivery_app/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });
  final String image, name, price;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1, totalPrice = 0;
  String? name, id, email, address;
  Map<String, dynamic>? paymentIntent; // Added missing variable
  bool isLoading = false; // Added loading state
  final _addressController = TextEditingController();

  getSharedPref() async {
    name = await SharedPrefHelper().getUserName();
    id = await SharedPrefHelper().getUserId();
    email = await SharedPrefHelper().getUserEmail();
    address = await SharedPrefHelper().getUserAddress();
    setState(() {});
  }

  @override
  void initState() {
    totalPrice = int.parse(widget.price);
    getSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.arrow_back, size: 30, color: Colors.white),
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
              Text(widget.name, style: AppWidget.headlineTextFieldStyle()),
              Text(
                '\$${widget.price}',
                style: AppWidget.simpleTextFieldStyle(),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  'Our classic cheese pizza is made with a hand-tossed crust, rich tomato basil sauce, and a blend of 100% mozzarella, provolone, and aged cheddar cheeses — melted to golden perfection. Finished with a touch of oregano for that perfect pizzeria flavor.',
                  style: AppWidget.simpleTextFieldStyle(),
                ),
              ),
              SizedBox(height: 20),
              Text('Quantity', style: AppWidget.simpleTextFieldStyle()),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 30),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '\$${totalPrice.toString()}',
                          style: AppWidget.boldBhiteTextFieldStyle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap:
                        isLoading
                            ? null
                            : () async {
                              // Convert price to cents for Stripe (multiply by 100)
                              await checkAddressAndProceed();
                            },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 60,
                        width: 180,
                        decoration: BoxDecoration(
                          color: isLoading ? Colors.grey : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child:
                              isLoading
                                  ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                  : Text(
                                    'Order Now',
                                    style: AppWidget.whiteTextFieldStyle(),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      setState(() {
        isLoading = true;
      });

      paymentIntent = await createPaymentIntent(amount, "INR");

      if (paymentIntent == null) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Failed to create payment intent');
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Food Delivery App',
          customFlow: false,
          setupIntentClientSecret: null,
        ),
      );

      await displayPaymentSheet();
    } catch (e, s) {
      print("Error in makePayment: $e stacktrace: $s");
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Payment failed. Please try again.');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      String orderId = randomAlphaNumeric(10);
      Map<String, dynamic> userOrderMap = {
        "OrderId": orderId,
        "Name": name,
        "Id": id,
        "Quantity": quantity.toString(),
        "Total": totalPrice.toString(),
        "Email": email,
        "FoodName": widget.name,
        "FoodImage": widget.image,
        "Status": "Pending",
        "Address": address ?? _addressController.text,
      };

      await DataBaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
      await DataBaseMethods().addAdminOrderDetails(userOrderMap, orderId);

      setState(() {
        isLoading = false;
      });

      // Payment successful
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Payment Successful'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 10),
                  Text('Your order has been placed successfully!'),
                  SizedBox(height: 10),
                  Text('Amount: \$${(totalPrice).toString()}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );

      paymentIntent = null;
    } on StripeException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.error.code == FailureCode.Canceled) {
        _showErrorDialog('Payment was cancelled');
      } else {
        print('Stripe error: $e');
        _showErrorDialog('Payment failed: ${e.error.localizedMessage}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error in displayPaymentSheet: $e');
      _showErrorDialog('Payment failed. Please try again.');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'Payment for ${widget.name} x $quantity',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error creating payment intent: ${response.body}');
        return null;
      }
    } catch (err) {
      print('Error creating payment intent: $err');
      return null;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddressInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delivery Address Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter your delivery address to continue'),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your delivery address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_addressController.text.trim().isNotEmpty) {
                  String newAddress = _addressController.text.trim();
                  await SharedPrefHelper().saveUserAddress(newAddress);
                  address = newAddress;
                  Navigator.of(context).pop();

                  // Now proceed with payment
                  String amountInCents = (totalPrice * 100).toString();
                  await makePayment(amountInCents);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid address'),
                      backgroundColor: Color(0xffef2b39),
                    ),
                  );
                }
              },
              child: Text('Save & Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkAddressAndProceed() async {
    // Check if address exists
    String? currentAddress = await SharedPrefHelper().getUserAddress();

    if (currentAddress == null || currentAddress.isEmpty) {
      // No address found, show dialog to enter address
      _showAddressInputDialog();
    } else {
      // Address exists, proceed with payment
      address = currentAddress;
      String amountInCents = (totalPrice * 100).toString();
      await makePayment(amountInCents);
    }
  }
}
