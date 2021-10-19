part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationUninitialized extends NotificationState {
  @override
  String toString() => 'Uninitialized';
}

class NotificationLoading extends NotificationState {
  @override
  String toString() => 'NotificationLoading';
}

class NotificationNotLoaded extends NotificationState {
  @override
  String toString() => 'NotificationNotLoaded';
}

class NotificationLoaded extends NotificationState {
  final List<Notification>? notifications;

  NotificationLoaded([this.notifications]);

  @override
  String toString() => 'NotificationLoaded';
}

