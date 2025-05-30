import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/service/constant.dart';
import 'package:food_delivery_app/service/database.dart';
import 'package:food_delivery_app/service/shared_pref.dart';
import 'package:food_delivery_app/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Map<String, dynamic>? paymentIntent;
  bool isLoading = false;
  bool isWalletLoading = true;
  Stream? transactionStream;

  String? email, wallet, id;
  TextEditingController amountController = TextEditingController();

  getSharedPref() async {
    email = await SharedPrefHelper().getUserEmail();
    id = await SharedPrefHelper().getUserId();
    print("email $email");
    setState(() {});
  }

  getUserWallet() async {
    setState(() {
      isWalletLoading = true;
    });

    await getSharedPref();
    transactionStream = await DataBaseMethods().getUsertransaction(id!);
    QuerySnapshot querySnapshot = await DataBaseMethods().getUserWalletByEmail(
      email!,
    );

    wallet = "${querySnapshot.docs[0]["Wallet"]}";
    print("Wallet ----> $wallet");

    setState(() {
      isWalletLoading = false;
    });
  }

  @override
  void initState() {
    getUserWallet();
    super.initState();
  }

  void _showCustomAmountDialog() {
    amountController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Money to Wallet', style: AppWidget.boldTextStyle()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the amount you want to add:',
                style: AppWidget.simpleTextFieldStyle(),
              ),
              SizedBox(height: 15),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixText: '\$',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xffef2b39), width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredAmount = amountController.text.trim();
                if (enteredAmount.isEmpty) {
                  _showErrorDialog('Please enter an amount');
                  return;
                }

                double? amount = double.tryParse(enteredAmount);
                if (amount == null || amount <= 0) {
                  _showErrorDialog('Please enter a valid amount');
                  return;
                }

                int amountInCents = (amount * 100).round();

                Navigator.of(context).pop();
                makePayment(amountInCents.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffef2b39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      setState(() {
        isLoading = true;
      });

      paymentIntent = await createPaymentIntent(amount, "USD");

      if (paymentIntent == null) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Failed to create payment intent');
        return;
      }

      String? clientSecret = paymentIntent?['client_secret'];
      if (clientSecret == null || clientSecret.isEmpty) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Invalid payment configuration');
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.dark,
          merchantDisplayName: 'Food Delivery App',
          customFlow: false,
          setupIntentClientSecret: null,
        ),
      );

      await displayPaymentSheet(amount);
    } catch (e, s) {
      print("Error in makePayment: $e stacktrace: $s");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Payment failed. Please try again.');
      }
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
            // Show loading while updating wallet
            setState(() {
              isLoading = true;
            });

            int amountInCents = int.parse(amount);
            int amountInDollars = (amountInCents / 100).round();

            int updatedWallet = int.parse(wallet!) + amountInDollars;
            await DataBaseMethods().updateWallet(updatedWallet.toString(), id!);
            await getUserWallet();

            DateTime now = DateTime.now();
            String formattedDate = DateFormat("dd MMM").format(now);

            Map<String, dynamic> userTransaction = {
              "Amount": amountInDollars.toString(),
              "Date": formattedDate,
            };

            await DataBaseMethods().addUserTransaction(userTransaction, id!);

            setState(() {
              isLoading = false;
            });

            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 10),
                            Text("Payment Successful"),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
            paymentIntent = null;
          })
          .onError((error, stacktree) {
            setState(() {
              isLoading = false;
            });
            print("Error updating the wallet $error & $stacktree");
          });
    } on StripeException catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error while adding money to wallet ---> $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error updating the wallet $e");
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

  Widget allTransaction() {
    return StreamBuilder(
      stream: transactionStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        ds["Date"],
                        style: AppWidget.headlineTextFieldStyle(),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text("Amount added to wallet"),
                          Text(
                            "\$${ds["Amount"]}",
                            style: TextStyle(
                              color: Color(0xffef2b39),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffef2b39)),
              ),
              SizedBox(height: 15),
              Text('Processing Payment...', style: AppWidget.boldTextStyle()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          isWalletLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xffef2b39),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Loading Wallet...', style: AppWidget.boldTextStyle()),
                  ],
                ),
              )
              : Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My Wallet",
                          style: AppWidget.headlineTextFieldStyle(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 3,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'images/wallet.png',
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 50),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Wallet",
                                            style: AppWidget.boldTextStyle(),
                                          ),
                                          Text(
                                            "\$${wallet!}",
                                            style:
                                                AppWidget.headlineTextFieldStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap:
                                        isLoading
                                            ? null
                                            : () {
                                              makePayment("10000");
                                            },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            isLoading
                                                ? Colors.grey[300]
                                                : Colors.white,
                                        border: Border.all(
                                          color:
                                              isLoading
                                                  ? Colors.grey
                                                  : Colors.black45,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\$100",
                                          style:
                                              AppWidget.simpleTextFieldStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        isLoading
                                            ? null
                                            : () {
                                              makePayment("20000");
                                            },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            isLoading
                                                ? Colors.grey[300]
                                                : Colors.white,
                                        border: Border.all(
                                          color:
                                              isLoading
                                                  ? Colors.grey
                                                  : Colors.black45,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\$200",
                                          style:
                                              AppWidget.simpleTextFieldStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        isLoading
                                            ? null
                                            : () {
                                              makePayment("5000");
                                            },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            isLoading
                                                ? Colors.grey[300]
                                                : Colors.white,
                                        border: Border.all(
                                          color:
                                              isLoading
                                                  ? Colors.grey
                                                  : Colors.black45,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\$50",
                                          style:
                                              AppWidget.simpleTextFieldStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap:
                                  isLoading
                                      ? null
                                      : () {
                                        _showCustomAmountDialog();
                                      },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:
                                      isLoading
                                          ? Colors.grey
                                          : Color(0xffef2b39),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    isLoading ? "Processing..." : "Add Money",
                                    style: AppWidget.boldBhiteTextFieldStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Your Transactions",
                                      style: AppWidget.boldTextStyle(),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                          3.3,
                                      child: allTransaction(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          // Loading overlay
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }
}
