import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_bloc.dart';
import 'data/repositories.dart';
import 'pages/home.dart';
import 'pages/login/login_page.dart';
import 'shared/loading_indicator.dart';
import 'shared/splash_page.dart';
void main() {
  final userRepository = UserRepository();
  final notificationRepository = NotificationRepository();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(userRepository: userRepository)..add(AppStarted());
      },
      child: App(
          userRepository: userRepository, 
          notificationRepository: notificationRepository
        ),
    ),
  );
}

class App extends StatelessWidget {

  final UserRepository userRepository;
  final NotificationRepository notificationRepository;

  const App(
      {Key? key,
      required this.userRepository,
      required this.notificationRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ThemeBloc(ThemeData.light()),
        child: BlocBuilder<ThemeBloc, ThemeData>(builder: (_, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              bloc: BlocProvider.of<AuthBloc>(context),
              builder: (BuildContext context, AuthState state) {
                if (state is Uninitialized) {
                  return const SplashPage();
                }
                if (state is Authenticated) {
                  return HomePage(userRepository: userRepository, notificationRepository: notificationRepository);
                }
                if (state is Unauthenticated) {
                  return LoginPage(userRepository: userRepository);
                }
                if (state is Loading) {
                  return const LoadingIndicator();
                }
                else {
                  return const LoadingIndicator();
                }
              },
            ),
            initialRoute: '/',
          );
        }));
  }
}

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc(ThemeData initialState) : super(initialState);

  ThemeData get initialState => ThemeData.light();

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    if (event == ThemeEvent.toggle) {
      if (state == ThemeData.dark()) {
        yield ThemeData.light();
      } else {
        yield ThemeData.dark();
      }
    }
  }
}
