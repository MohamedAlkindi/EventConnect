import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  @JsonKey(includeIfNull: false)
  String? eventID;
  final String name;
  final String category;
  // Not final, used in caching and returning cached data later..
  String? cachedPicturePath;
  // Added this to store the picture link inside the Supabase.
  final String pictureUrl;
  final String location;
  final String dateAndTime;
  final String description;
  final String genderRestriction;
  @JsonKey(includeIfNull: false)
  // String? weather;
  int attendees;
  final String managerID;

  EventModel({
    required this.eventID,
    required this.pictureUrl,
    required this.name,
    required this.category,
    required this.cachedPicturePath,
    required this.location,
    required this.dateAndTime,
    required this.description,
    required this.genderRestriction,
    // this.weather,
    this.attendees = 0,
    required this.managerID,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{};
    if (name.isNotEmpty) data['name'] = name;
    if (category.isNotEmpty) data['category'] = category;
    if (pictureUrl.isNotEmpty) data['pictureUrl'] = pictureUrl;
    if (location.isNotEmpty) data['location'] = location;
    if (dateAndTime.isNotEmpty) data['dateAndTime'] = dateAndTime;
    if (description.isNotEmpty) data['description'] = description;
    if (genderRestriction.isNotEmpty) {
      data['genderRestriction'] = genderRestriction;
    }
    // if (weather != null) data['weather'] = weather;
    // Do NOT include attendees unless you want to update it!
    // if (attendees != null) data['attendees'] = attendees;
    if (managerID.isNotEmpty) data['managerID'] = managerID;
    return data;
  }
}
