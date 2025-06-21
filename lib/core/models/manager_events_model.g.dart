// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_events_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerEvents _$ManagerEventsFromJson(Map<String, dynamic> json) =>
    ManagerEvents(
      managerEventID: json['managerEventID'] as String,
      userID: json['userID'] as String,
      eventID: json['eventID'] as String,
    );

Map<String, dynamic> _$ManagerEventsToJson(ManagerEvents instance) =>
    <String, dynamic>{
      'managerEventID': instance.managerEventID,
      'userID': instance.userID,
      'eventID': instance.eventID,
    };
