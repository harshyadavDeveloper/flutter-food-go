import 'package:flutter/material.dart';
import 'package:food_delivery_app/service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Image.asset('images/onboard.png'),
            SizedBox(height: 20),
            Text(
              'The Fastest\nFood Delivery',
              textAlign: TextAlign.center,
              style: AppWidget.headlineTextFieldStyle(),
            ),
            SizedBox(height: 20),
            Text(
              'Craving Something Delicious?\nOrder now and get your favourites\ndelivered fast!!!',
              textAlign: TextAlign.center,
              style: AppWidget.simpleTextFieldStyle(),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Color(0xff8c592a),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Get Started",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
