import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:public/data/repositories.dart';
import 'package:public/shared/loading_indicator.dart';

import 'bloc/notification_bloc.dart';

class NotificationPage extends StatefulWidget {
  final NotificationRepository _notificationRepository;

  const NotificationPage({Key? key, required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late NotificationBloc _notificationBloc;
  NotificationRepository get _notificationRepository => widget._notificationRepository;
  Completer<void>? _refreshCompleter;
  late int rebuilt;


  @override
  void initState() {
    rebuilt = 0;
    _notificationBloc = NotificationBloc(notificationRepository: _notificationRepository)
      ..add(LoadNotification());
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _notificationBloc,
      listener: (context, state) {
        if (state is NotificationLoaded) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder(
        bloc: _notificationBloc,
        builder: (context, state) {
          if (state is NotificationUninitialized) {
            return const Text("Notifactions not loading at this time.");
          } else if (state is NotificationNotLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('ERROR!'),
                backgroundColor: Colors.red,
                elevation: 0.0,
              ),
            );
          } else if (state is NotificationLoading) {
            return const LoadingIndicator();
          } else if (state is NotificationLoaded) {
            var notifications = state.notifications;
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 5,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: ListView.builder(
                itemCount: notifications!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print('tapped');
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifications[index].title ?? "", 
                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              notifications[index].message ?? "", 
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        )
                      ),
                    ),
                  );
                }
              )
            );
          } else {
            return const LoadingIndicator();
          }
        },
      ),
    );
  }
}
