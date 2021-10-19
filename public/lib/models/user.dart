import 'package:json_annotation/json_annotation.dart';

import 'notification.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  String? id;
  String? email;
  List<Notification>? notifications;
  String? token;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  User(
    this.id,
    this.email,
    this.notifications,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
