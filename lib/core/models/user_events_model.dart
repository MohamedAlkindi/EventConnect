import 'package:json_annotation/json_annotation.dart';

part 'user_events_model.g.dart';

@JsonSerializable()
class UserEvents {
  final String userEventID;
  final String userID;
  final String eventID;

  UserEvents({
    required this.userEventID,
    required this.userID,
    required this.eventID,
  });

  factory UserEvents.fromJson(Map<String, dynamic> json) =>
      _$UserEventsFromJson(json);

  Map<String, dynamic> toJson() => _$UserEventsToJson(this);
}
