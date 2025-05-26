import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/all_orders.dart';
import 'package:food_delivery_app/admin/manage_users.dart';
import 'package:food_delivery_app/service/widget_support.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Admin Home", style: AppWidget.headlineTextFieldStyle()),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AllOrders()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20, left: 20),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),

                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'images/delivery-man.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Manage\nOrders",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffef2b39),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageUsers(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20, left: 20),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),

                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'images/team.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Manage\nUsers",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffef2b39),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
