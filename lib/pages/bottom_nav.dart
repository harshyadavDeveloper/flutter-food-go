import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/home.dart';
import 'package:food_delivery_app/pages/order.dart';
import 'package:food_delivery_app/pages/profile.dart';
import 'package:food_delivery_app/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home homePage;
  late Order orderPage;
  late Wallet walletPage;
  late Profile profilePage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = Home();
    orderPage = Order();
    walletPage = Wallet();
    profilePage = Profile();

    pages = [homePage, orderPage, walletPage, profilePage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(microseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 30,
            ),
            Icon(
              Icons.wallet,
              color: Colors.white,
              size: 30,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
