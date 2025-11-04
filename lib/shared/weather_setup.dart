// import 'package:event_connect/core/models/event_model.dart';
// import 'package:event_connect/core/service/api_service.dart';

// class WeatherSetup {
//   final _apiService = ApiService();

//   DateTime getDate(String dateTime) {
//     final date = dateTime.split(' ')[0];
//     return DateTime.parse(date);
//   }

//   Future<void> setupWeather(List<EventModel> events) async {
//     await Future.wait(events.map((event) async {
//       event.weather = await _apiService.getWeatherForDate(
//         date: getDate(event.dateAndTime),
//         location: event.location,
//       );
//     }));
//   }
// }
