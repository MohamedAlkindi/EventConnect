import 'package:json_annotation/json_annotation.dart';

part 'manager_events_model.g.dart';

@JsonSerializable()
class ManagerEvents {
  final String managerEventID;
  final String userID;
  final String eventID;

  ManagerEvents({
    required this.managerEventID,
    required this.userID,
    required this.eventID,
  });

  factory ManagerEvents.fromJson(Map<String, dynamic> json) =>
      _$ManagerEventsFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerEventsToJson(this);
}
