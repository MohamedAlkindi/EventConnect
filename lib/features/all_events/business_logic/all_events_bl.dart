import 'dart:convert';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/tables/events_table.dart';
// import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/features/all_events/data_access/all_events_da.dart';
import 'package:http/http.dart' as http;

class AllEventScreenBL {
  final AllEventScreenDA _dataAccess = AllEventScreenDA();
  static const String _apiKey =
      '0c33a0738b124d4380d103602252604'; // Get from weatherapi.com
  static const String _baseUrl = 'http://api.weatherapi.com/v1';

  DateTime getDate(String dateTime) {
    final date = dateTime.split(' ')[0];
    return DateTime.parse(date);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      var events = await _dataAccess.getAllEvents();
      List<Map<String, dynamic>> updatedEvents = [];

      for (var event in events) {
        final weatherData = await getWeatherForDate(
          date: getDate(event[EventsTable.eventDateTimeColumnName]),
          location: event[EventsTable.eventLocationColumnName],
        );
        updatedEvents.add({
          ...event,
          'Weather': weatherData,
        });
      }

      return updatedEvents;
    } catch (e) {
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getEventsByCategory(
      {required String category}) async {
    try {
      return await _dataAccess.getEventsByCategory(category: category);
    } catch (e) {
      // For now...
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<void> addEventToUserEvents(int eventID) async {
    try {
      await _dataAccess.addEventToUserEvents(eventID);
    } catch (e) {
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<String> getWeatherForDate({
    required DateTime date,
    required String location,
  }) async {
    try {
      // Format date as yyyy-MM-dd for WeatherAPI
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Encode the location parameter to handle spaces and special characters
      final encodedLocation = Uri.encodeComponent(location);
      print('Encoded location: $encodedLocation'); // Debug log
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
      print('Final URL: $url'); // Debug log

      final response = await http.get(Uri.parse(url));

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
          throw GenericException(
              message: 'Forecast data not available for the specified date');
        } else {
          // For history, use the historical data
          final temp = data['forecast']['forecastday'][0]['day']['avgtemp_c'];
          return temp.toString();
        }
      } else {
        // Add more detailed error information
        final errorData = jsonDecode(response.body);
        throw GenericException(
          message:
              'Failed to get weather data: ${response.statusCode} - ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw GenericException(
        message: 'Error getting weather: ${e.toString()}',
      );
    }
  }
}
