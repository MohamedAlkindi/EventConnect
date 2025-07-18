import 'dart:convert';
import 'dart:developer' as log;
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey =
      '0c33a0738b124d4380d103602252604'; // Get from weatherapi.com
  static const String _baseUrl = 'http://api.weatherapi.com/v1';

  Future<String?> getWeatherForDate({
    required DateTime date,
    required String location,
  }) async {
    try {
      // Format date as yyyy-MM-dd for WeatherAPI
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Encode the location parameter to handle spaces and special characters
      final encodedLocation = Uri.encodeComponent(location);
      log.log('Encoded location: $encodedLocation'); // Debug log
      // Determine if we need to use forecast or history endpoint
      final now = DateTime.now();
      final isFutureDate = date.isAfter(now);

      String url;
      if (isFutureDate) {
        // Use forecast endpoint for future dates
        url = '$_baseUrl/forecast.json?key=$_apiKey&q=$encodedLocation&days=10';
      } else {
        // Use history endpoint for past dates
        url =
            '$_baseUrl/history.json?key=$_apiKey&q=$encodedLocation&dt=$formattedDate';
      }
      log.log('Final URL: $url'); // Debug log

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw GenericException(
            'Request timed out. Please try again later.',
          );
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (isFutureDate) {
          // For forecast, find the matching date in the forecast data
          final forecastDays = data['forecast']['forecastday'];
          for (var day in forecastDays) {
            if (day['date'] == formattedDate) {
              return day['day']['avgtemp_c'].toString();
            }
          }
          return null;
        } else {
          // For history, use the historical data
          final temp = data['forecast']['forecastday'][0]['day']['avgtemp_c'];
          return temp.toString();
        }
      } else {
        // Add more detailed error information
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
