import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/all_events/data_access/all_events_da.dart';

class AllEventScreenBL {
  final AllEventScreenDA _dataAccess = AllEventScreenDA();

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      return await _dataAccess.getAllEvents();
    } catch (e) {
      // For now...
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<List<Map<String, dynamic>>> gettEventsByCategory(
      {required String category}) async {
    try {
      return await _dataAccess.getEventsByCategory(category: category);
    } catch (e) {
      // For now...
      throw GenericException(
          message: ExceptionMessages.genericExceptionMessage);
    }
  }
}
