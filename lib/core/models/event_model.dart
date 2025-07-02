import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  @JsonKey(includeIfNull: false)
  String? eventID;
  final String name;
  final String category;
  // Not final, used in caching and returning cached data later..
  String picture;
  final String location;
  final String dateAndTime;
  final String description;
  final String genderRestriction;
  @JsonKey(includeIfNull: false)
  String? weather;
  int attendees;
  final String managerID;

  EventModel(this.eventID,
      {required this.name,
      required this.category,
      required this.picture,
      required this.location,
      required this.dateAndTime,
      required this.description,
      required this.genderRestriction,
      this.weather,
      this.attendees = 0,
      required this.managerID});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
