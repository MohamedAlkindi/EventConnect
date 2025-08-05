// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userID: json['userID'] as String,
      location: json['location'] as String,
      profilePicUrl: json['profilePicUrl'] as String,
      cachedPicturePath: json['cachedPicturePath'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userID': instance.userID,
      'location': instance.location,
      'profilePicUrl': instance.profilePicUrl,
      if (instance.cachedPicturePath case final value?)
        'cachedPicturePath': value,
      'role': instance.role,
    };
