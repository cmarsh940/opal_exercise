import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public/data/repositories.dart';

import 'login.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  const LoginPage({Key? key, required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: userRepository),
        child: LoginForm(userRepository: userRepository),
      ),
    );
  }
}