// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    json['_id'] as String?,
    json['viewed'] as bool?,
    json['viewedDate'] == null
        ? null
        : DateTime.parse(json['viewedDate'] as String),
    json['title'] as String?,
    json['message'] as String?,
    json['user'] as String?,
    json['createdAt'] as String?,
    json['updatedAt'] as String?,
    json['__v'] as int?,
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'viewed': instance.viewed,
      'viewedDate': instance.viewedDate?.toIso8601String(),
      'title': instance.title,
      'message': instance.message,
      'user': instance.user,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
    };
