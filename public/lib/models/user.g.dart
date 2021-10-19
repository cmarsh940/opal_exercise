// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['_id'] as String?,
    json['email'] as String?,
    (json['notifications'] as List<dynamic>?)
        ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['token'] as String?,
    json['createdAt'] as String?,
    json['updatedAt'] as String?,
    json['__v'] as int?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'notifications': instance.notifications?.map((e) => e.toJson()).toList(),
      'token': instance.token,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
    };
