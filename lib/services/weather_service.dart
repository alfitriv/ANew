import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anew_project/constants.dart';

class WeatherService {
  final String baseUrl = ApiConstants.baseUrl;
  final String apiKey = ApiConstants.apiKey;

  // Fetches current UV index and hourly forecast data
  Future<Map<String, dynamic>> fetchUVIndexAndTimeRange(String location) async {
    final currentUrl = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$location');
    final forecastUrl = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$location&hourly=uv&days=1');

    try {
      // Fetch the current UV index
      final currentResponse = await http.get(currentUrl);
      if (currentResponse.statusCode != 200) {
        throw Exception('Failed to load current UV data');
      }
      final currentData = jsonDecode(currentResponse.body);
      final currentUV = currentData['current']['uv'] ?? 0.0;

      // Fetch hourly UV forecast
      final forecastResponse = await http.get(forecastUrl);
      if (forecastResponse.statusCode != 200) {
        throw Exception('Failed to load UV forecast data');
      }
      final forecastData = jsonDecode(forecastResponse.body);

      if (forecastData['forecast'] == null || forecastData['forecast']['forecastday'] == null) {
        throw Exception('UV forecast data is missing');
      }

      List<Map<String, dynamic>> uvTimeRanges = [];
      final hours = forecastData['forecast']['forecastday'][0]['hour'];

      DateTime? startTime;
      double? uvStart;
      for (var hour in hours) {
        final uvIndex = hour['uv'];
        final time = hour['time']; // Time of the forecast (e.g., 10:00 AM)

        if (uvIndex >= currentUV) {
          // If UV index is above or equal to the current index and we haven't started a range yet
          if (startTime == null) {
            startTime = DateTime.parse(time);
            uvStart = uvIndex;
          }
        } else {
          // If UV index drops below the current index, close the previous range if applicable
          if (startTime != null && uvStart != null) {
            uvTimeRanges.add({
              'start_time': startTime.toLocal().toString(),
              'end_time': DateTime.parse(hour['time']).toLocal().toString(),
              'uv_start': uvStart,
              'uv_end': uvIndex,
            });
            startTime = null; // Reset for the next range
          }
        }
      }

      // Handle the case where the UV index is still above the threshold at the end of the forecast period
      if (startTime != null) {
        uvTimeRanges.add({
          'start_time': startTime.toLocal().toString(),
          'end_time': DateTime.parse(hours.last['time']).toLocal().toString(),
          'uv_start': uvStart,
          'uv_end': hours.last['uv'],
        });
      }

      // Return both the current UV index and the time ranges
      return {
        'current_uv': currentUV,
        'uv_time_ranges': uvTimeRanges,
      };
    } catch (error) {
      print('Error fetching UV index and time range: $error');
      return {
        'current_uv': 0.0,
        'uv_time_ranges': [],
      };
    }
  }
}
