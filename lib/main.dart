import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'services/weather_service.dart'; // Make sure this import is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
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
                      FutureBuilder<Map<String, dynamic>>(
                        future: weatherService.fetchUVIndexAndTimeRange(selectedLocation),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching UV index'));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!;
                            final uvIndex = data['uvIndex'] as double?;
                            final lightCondition = (uvIndex != null && uvIndex < 3) ? "Limited Light" : "Normal Light";

                            return Row(
                              children: [
                                Text(
                                  _formatDate(DateTime.now()), // Format the current date
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '| $lightCondition',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(child: Text('No data available'));
                          }
                        },
                      ),


                      // UV Index and Main Message
                      const SizedBox(height: 24.0),
                      FutureBuilder<Map<String, dynamic>>(
                        future: weatherService.fetchUVIndexAndTimeRange(selectedLocation),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching UV index and time range'));
                          } else {
                            final uvIndex = snapshot.data?['current_uv'];
                            final uvTimeRanges = snapshot.data?['uv_time_ranges'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      // TextSpan(
                                      //   text: 'UV Index: ${uvIndex?.toStringAsFixed(1) ?? 'Unavailable'}\n\n',
                                      //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      // ),
                                      if (uvIndex == null) ...[
                                        const TextSpan(
                                          text: "UV data is unavailable. Stay cautious.\n",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ] else if (uvIndex < 3) ...[
                                        const TextSpan(
                                          text: "It’s ",
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.normal),
                                        ),
                                        const TextSpan(
                                          text: "very important ",
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: "to ",
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.normal),
                                        ),
                                        const TextSpan(
                                          text: "go outside and get natural light \n",
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                        ),
                                      ] else if (uvIndex >= 3 && uvIndex < 6) ...[
                                        const TextSpan(
                                          text: "Moderate UV index. ",
                                          style: TextStyle(fontSize: 36.0),
                                        ),
                                        const TextSpan(
                                          text: "All good, ",
                                          style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: "go outside and enjoy the day!\n",
                                          style: TextStyle(fontSize: 36.0),
                                        ),
                                      ] else if (uvIndex >= 6 && uvIndex < 8) ...[
                                        const TextSpan(
                                          text: "High UV index! ",
                                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: "Limit your time outdoors and wear strong sun protection.\n",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ] else ...[
                                        const TextSpan(
                                          text: "Very high UV index! ",
                                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: "Avoid going outside if possible during peak hours.\n",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                // Show time range for UV index above threshold
                                const SizedBox(height: 1.0),
                                if (uvTimeRanges?.isNotEmpty ?? false)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // const Text(
                                      //   'UV Index Above Threshold:',
                                      //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      // ),
                                      ...uvTimeRanges!.map((range) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            'from ${_formatTime(range['start_time'])} to ${_formatTime(range['end_time'])}',
                                            style: const TextStyle(fontSize: 36.0),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                              ],
                            );
                          }
                        },
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
                            // Handle sign-up process (e.g., submit email)
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
                            'SIGN UP NOW',
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
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

  // Function to format date to 'hh:MM a' format
  String _formatDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);  // Format as 26 November 2024
  }

  // Function to format time to 'hh:MM a' format
  String _formatTime(String time) {
    DateTime parsedTime = DateTime.parse(time);
    return DateFormat('hh:mm a').format(parsedTime); // Format to 12-hour with AM/PM
  }

  // Function to show location picker dialog
  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: locations.map((location) {
                return ListTile(
                  title: Text(location),
                  onTap: () {
                    setState(() {
                      selectedLocation = location;
                    });
                    Navigator.pop(context); // Close dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
