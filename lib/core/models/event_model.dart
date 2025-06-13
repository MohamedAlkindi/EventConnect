import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final String eventID;
  final String name;
  final String category;
  final String picture;
  final String location;
  final String dateAndTime;
  final String discription;
  final String genderRestriction;
  String? weather;

  EventModel(
      {required this.eventID,
      required this.name,
      required this.category,
      required this.picture,
      required this.location,
      required this.dateAndTime,
      required this.discription,
      required this.genderRestriction,
      this.weather});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
