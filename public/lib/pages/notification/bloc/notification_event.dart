part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class LoadNotification extends NotificationEvent {
  @override
  String toString() => 'LoadNotification';
}

class CreateNotification extends NotificationEvent {
  @override
  String toString() => 'CreateNotification';
}

class Refresh extends NotificationEvent {
  @override
  String toString() => 'Refresh';
}
