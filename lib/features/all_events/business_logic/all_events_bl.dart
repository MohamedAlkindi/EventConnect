import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/service/api_service.dart';
import 'package:event_connect/core/tables/events_table.dart';
// import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/features/all_events/data_access/all_events_da.dart';

class AllEventScreenBL {
  final AllEventScreenDA _dataAccess = AllEventScreenDA();
  final ApiService apiService = ApiService();

  DateTime getDate(String dateTime) {
    final date = dateTime.split(' ')[0];
    return DateTime.parse(date);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      var events = await _dataAccess.getAllEvents();
      List<Map<String, dynamic>> updatedEvents = [];

      for (var event in events) {
        final weatherData = await apiService.getWeatherForDate(
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
      throw GenericException(message: ExceptionMessages.apiError);
    }
  }

  Future<List<Map<String, dynamic>>> getEventsByCategory(
      {required String category}) async {
    try {
      return await _dataAccess.getEventsByCategory(category: category);
    } catch (e) {
      // For now...
      throw GenericException(message: ExceptionMessages.categoryError);
    }
  }

  Future<void> addEventToUserEvents(int eventID) async {
    try {
      await _dataAccess.addEventToUserEvents(eventID);
    } catch (e) {
      throw GenericException(
          message: ExceptionMessages.addEventError);
    }
  }
}
