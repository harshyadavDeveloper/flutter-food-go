import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/admin_home.dart';
import 'package:food_delivery_app/service/widget_support.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // Changed from final to regular bool

  loginAdmin() async {
    // Show loading state
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("Admin").get().then((
        snapshot,
      ) {
        bool loginSuccess = false;

        for (var result in snapshot.docs) {
          if (result.data()['username'] != usernameController.text.trim()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Username provided is not correct',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (result.data()['password'] != passwordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Password provided is not correct',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            loginSuccess = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Login Success',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green, // Changed to green for success
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushReplacement(
              // Use pushReplacement to prevent going back
              context,
              MaterialPageRoute(builder: (context) => AdminHome()),
            );
            break; // Exit loop once login is successful
          }
        }
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed. Please try again.',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      // Hide loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffefbf),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'images/pan.png',
                    height: 180,
                    fit: BoxFit.fill,
                    width: 240,
                  ),
                  Image.asset(
                    'images/logo.png',
                    height: 50,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.8,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            "Admin Login",
                            style: AppWidget.headlineTextFieldStyle(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text("Name", style: AppWidget.signupTextFieldStyle()),
                        SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: usernameController,
                            enabled: !_isLoading, // Disable when loading
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter username",
                              prefixIcon: Icon(Icons.person_outlined),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0),
                        Text(
                          "Password",
                          style: AppWidget.signupTextFieldStyle(),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            enabled: !_isLoading, // Disable when loading
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Password",
                              prefixIcon: Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed:
                                    _isLoading
                                        ? null
                                        : () {
                                          // Disable when loading
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap:
                              _isLoading
                                  ? null
                                  : loginAdmin, // Added onTap with function call
                          child: Center(
                            child: Container(
                              width: 180,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    _isLoading
                                        ? Colors
                                            .grey // Change color when loading
                                        : Color(0xffef2b39),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child:
                                    _isLoading
                                        ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          "Login",
                                          style:
                                              AppWidget.boldBhiteTextFieldStyle(),
                                        ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
