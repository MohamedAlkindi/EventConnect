import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:event_connect/core/models/event_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleEventNotifications(EventModel event) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'event_reminder_channel',
      'Event Reminders',
      channelDescription: 'Reminders for your scheduled events',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final eventDateTime = DateTime.parse(event.dateAndTime);
    final eventDayMidnight =
        DateTime(eventDateTime.year, eventDateTime.month, eventDateTime.day);
    final threeHoursBefore = eventDateTime.subtract(const Duration(hours: 3));
    try {
      // Schedule notification at 00:00 on event day
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.hashCode, // unique id
        'Event Today: ${event.name}',
        'Don\'t forget your event: ${event.name} is today!',
        tz.TZDateTime.from(eventDayMidnight, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
      // Schedule notification 3 hours before event
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.hashCode + 1, // unique id
        'Event Reminder: ${event.name}',
        'Your event starts in 3 hours at ${event.location}',
        tz.TZDateTime.from(threeHoursBefore, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {}
  }

  Future<void> cancelEventNotifications(EventModel event) async {
    await flutterLocalNotificationsPlugin.cancel(event.hashCode);
    await flutterLocalNotificationsPlugin.cancel(event.hashCode + 1);
  }
}

class NotificationEventListener {
  final Stream<List<EventModel>> eventsStream;
  List<EventModel> _previousEvents = [];

  NotificationEventListener(this.eventsStream) {
    eventsStream.listen(_onEventsChanged);
  }

  void _onEventsChanged(List<EventModel> currentEvents) {
    // Find added events
    final addedEvents = currentEvents
        .where((e) => !_previousEvents.any((old) => old.eventID == e.eventID))
        .toList();
    // Find removed events
    final removedEvents = _previousEvents
        .where((old) => !currentEvents.any((e) => e.eventID == old.eventID))
        .toList();

    for (final event in addedEvents) {
      NotificationService().scheduleEventNotifications(event);
    }
    for (final event in removedEvents) {
      NotificationService().cancelEventNotifications(event);
    }
    _previousEvents = List<EventModel>.from(currentEvents);
  }
}
