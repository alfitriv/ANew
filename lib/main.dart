import 'package:flutter/material.dart';
import 'services/weather_service.dart'; // Make sure this import is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  String selectedLocation = 'Seattle'; // Default location

  // List of sample locations for the user to pick from
  final List<String> locations = ['Seattle', 'Los Angeles', 'Sydney', 'Dubai', 'Rio de Janeiro'];
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine spacer flex values based on screen width
    int sideFlex = screenWidth < 600 ? 1 : 3;

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
                        child: GestureDetector(
                          onTap: () {
                            _showLocationPicker(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              selectedLocation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // UV Index
                      const SizedBox(height: 16.0),
                      FutureBuilder<double?>(
                        future: weatherService.fetchUVIndex(selectedLocation),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching UV index'));
                          } else {
                            final uvIndex = snapshot.data;
                            return Text(
                              'UV Index: ${uvIndex ?? 'Unavailable'}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }
                        },
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
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'name@email.com',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0), // Black underline
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0), // Black underline when enabled
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue underline when focused
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Here you could handle the sign-up process (e.g., submit email)
                            print('Email Submitted: ${emailController.text}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            minimumSize: const Size(0, 60),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.black87),
                          ),
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

  // Function to show the location picker (DropdownButton)
  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: locations.map((location) {
              return ListTile(
                title: Text(location),
                onTap: () {
                  setState(() {
                    selectedLocation = location; // Update selected location
                  });
                  Navigator.pop(context); // Close dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
