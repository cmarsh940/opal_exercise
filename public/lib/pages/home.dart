import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public/auth/auth_bloc.dart';
import 'package:public/data/repositories.dart';
import 'package:public/pages/notification/notification_page.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  final UserRepository userRepository;
  final NotificationRepository notificationRepository;

  const HomePage(
      {Key? key,
      required UserRepository userRepository,
      required NotificationRepository notificationRepository})
      : userRepository = userRepository,
        notificationRepository = notificationRepository,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationRepository get notificationRepository =>
      widget.notificationRepository;
  UserRepository get userRepository => widget.userRepository;
  bool? darkTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: const Icon(Icons.add_box_rounded),
            color: Theme.of(context).secondaryHeaderColor,
            tooltip: 'logout',
            onPressed: () {
              notificationRepository.addNotification();
              html.window.location.reload();
            },
          ),
        ),
        title: const Text("Opal Exercise"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              color: Theme.of(context).secondaryHeaderColor,
              tooltip: 'logout',
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  LoggedOut(),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: NotificationPage(notificationRepository: notificationRepository),
    );
  }
}
