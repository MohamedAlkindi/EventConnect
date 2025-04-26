import 'dart:convert';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/all_events/data_access/all_events_da.dart';
import 'package:http/http.dart' as http;

class AllEventScreenBL {
  final AllEventScreenDA _dataAccess = AllEventScreenDA();
  static const String _apiKey =
      '0c33a0738b124d4380d103602252604'; // Get from weatherapi.com
  static const String _baseUrl = 'http://api.weatherapi.com/v1';

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      var events = await _dataAccess.getAllEvents();
      // for (var event in events) {
      //   event['Weather'] = await getWeatherForDate(
      //       DateTime.parse(event['DateAndTime']), event['Location']);
      // }
      return events;
    } catch (e) {
      // For now...
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
      return await _dataAccess.addEventToUserEvents(eventID);
    } catch (e) {
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<double> getWeatherForDate(DateTime date, String location) async {
    try {
      // WeatherAPI allows historical data up to 7 days in the past
      final formattedDate = date.toIso8601String().split('T')[0];

      final response = await http.get(
        Uri.parse(
            '$_baseUrl/history.json?key=$_apiKey&q=$location&dt=$formattedDate'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract temperature from response
        final temp = data['forecast']['forecastday'][0]['day']['avgtemp_c'];
        return temp.toDouble();
      } else {
        throw GenericException(
          message: 'Failed to get weather data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw GenericException(
        message: 'Error getting weather: ${e.toString()}',
      );
    }
  }
}
