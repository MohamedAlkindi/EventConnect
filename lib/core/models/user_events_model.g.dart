// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_events_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEvents _$UserEventsFromJson(Map<String, dynamic> json) => UserEvents(
      userEventID: json['userEventID'] as String,
      userID: json['userID'] as String,
      eventID: json['eventID'] as String,
    );

Map<String, dynamic> _$UserEventsToJson(UserEvents instance) =>
    <String, dynamic>{
      'userEventID': instance.userEventID,
      'userID': instance.userID,
      'eventID': instance.eventID,
    };
