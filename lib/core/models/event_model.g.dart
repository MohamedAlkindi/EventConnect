// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      eventID: json['eventID'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      picture: json['picture'] as String,
      location: json['location'] as String,
      dateAndTime: json['dateAndTime'] as String,
      description: json['description'] as String,
      genderRestriction: json['genderRestriction'] as String,
      weather: json['weather'] as String?,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'eventID': instance.eventID,
      'name': instance.name,
      'category': instance.category,
      'picture': instance.picture,
      'location': instance.location,
      'dateAndTime': instance.dateAndTime,
      'discription': instance.description,
      'genderRestriction': instance.genderRestriction,
      'weather': instance.weather,
    };
