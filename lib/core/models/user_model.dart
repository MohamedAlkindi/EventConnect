import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userID;
  final String location;
  // similar to event model
  String profilePicUrl;
  @JsonKey(includeIfNull: false)
  String? cachedPicturePath;
  final String role;

  UserModel({
    required this.userID,
    required this.location,
    required this.profilePicUrl,
    required this.cachedPicturePath,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
