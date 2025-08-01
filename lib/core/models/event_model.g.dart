// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      eventID: json['eventID'] as String?,
      pictureUrl: json['pictureUrl'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      cachedPicturePath: json['cachedPicturePath'] as String?,
      location: json['location'] as String,
      dateAndTime: json['dateAndTime'] as String,
      description: json['description'] as String,
      genderRestriction: json['genderRestriction'] as String,
      weather: json['weather'] as String?,
      attendees: (json['attendees'] as num?)?.toInt() ?? 0,
      managerID: json['managerID'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      if (instance.eventID case final value?) 'eventID': value,
      'name': instance.name,
      'category': instance.category,
      'cachedPicturePath': instance.cachedPicturePath,
      'pictureUrl': instance.pictureUrl,
      'location': instance.location,
      'dateAndTime': instance.dateAndTime,
      'description': instance.description,
      'genderRestriction': instance.genderRestriction,
      if (instance.weather case final value?) 'weather': value,
      'attendees': instance.attendees,
      'managerID': instance.managerID,
    };
