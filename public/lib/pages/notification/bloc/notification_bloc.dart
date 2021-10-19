import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:public/data/repositories.dart';
import 'package:public/models/notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(NotificationInitial());

  NotificationState get initialState => NotificationLoading();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is LoadNotification) {
      yield* _mapLoadNotificationToState();
    } else if (event is Refresh) {
      yield* _mapLoadNotificationToState();
    } else if (event is CreateNotification) {
      yield* _mapCreateNotificationToState();
    }
  }

  Stream<NotificationState> _mapLoadNotificationToState() async* {
    var notifications = await _notificationRepository.getNotifications();
    List<Notification> newNotifications = [];

    if (notifications != null) {
      List subsResponseJson = json.decode(notifications);
      var newSubsStreams =
          subsResponseJson.map((m) => Notification.fromJson(m)).toList();
      newSubsStreams.forEach((a) {
        newNotifications.add(a);
      });
      yield NotificationLoaded(newNotifications);
    } else {
      yield NotificationNotLoaded();
    }
  }

  Stream<NotificationState> _mapCreateNotificationToState() async* {
    var notifications = await _notificationRepository.getNotifications();
    List<Notification> newNotifications = [];

    if (notifications != null) {
      List subsResponseJson = json.decode(notifications);
      var newSubsStreams =
          subsResponseJson.map((m) => Notification.fromJson(m)).toList();
      newSubsStreams.forEach((a) {
        newNotifications.add(a);
      });
      yield NotificationLoaded(newNotifications);
    } else {
      yield NotificationNotLoaded();
    }
  }
}
