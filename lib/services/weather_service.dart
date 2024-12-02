import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anew_project/constants.dart';

class WeatherService {
  final String baseUrl = ApiConstants.baseUrl;
  final String apiKey = ApiConstants.apiKey;

  Future<double?> fetchUVIndex(String location) async {
    final url = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$location');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the expected data is available
        if (data['current'] != null && data['current']['uv'] != null) {
          return data['current']['uv']; // Extract the UV index
        } else {
          throw Exception('UV data is not available');
        }
      } else {
        throw Exception('Failed to load UV data');
      }
    } catch (error) {
      print('Error fetching UV index: $error');
      return null;
    }
  }
}
