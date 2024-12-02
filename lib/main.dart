import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine spacer flex values based on screen width
    int sideFlex = screenWidth < 600 ? 1 : 3; // Smaller spacers for narrower screens

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0), // Top and bottom margins
          child: SingleChildScrollView(
            child: Row(
              children: [
                Spacer(flex: sideFlex), // Left spacer (dynamic)
                Expanded(
                  flex: 4, // Middle section (fixed width ratio)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Badge
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text(
                            'Seattle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),

                      // Date and Light Condition
                      const SizedBox(height: 16.0),
                      const Text(
                        '26 November 2024  •  Limited Light',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      // Main Message
                      const SizedBox(height: 24.0),
                      const Text.rich(
                        TextSpan(
                          text: "It's ",
                          style: TextStyle(fontSize: 42.0, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'very important ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'to ',
                            ),
                            TextSpan(
                              text: 'go outside and get natural light\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'from 11:00 AM - 2:00 PM.',
                            ),
                          ],
                        ),
                      ),

                      // Email Input and Signup Button
                      const SizedBox(height: 32.0),
                      const Text(
                        'Drop us your email to learn more about your health.',
                        style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'name@email.com',
                          hintStyle: TextStyle(color: Colors.black38),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0), // Black underline
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0), // Black underline when enabled
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue underline when focused
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.black, width: 1)
                            ),
                            minimumSize: Size(0, 60),
                          ),
                          child: const Text('Sign up',
                          style: TextStyle(color: Colors.black87)),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: sideFlex), // Right spacer (dynamic)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
