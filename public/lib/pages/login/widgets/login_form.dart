import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public/auth/auth_bloc.dart';
import 'package:public/data/repositories.dart';


import '../login.dart';
import 'create_account_button.dart';

// FacebookLogin _facebookLogin = FacebookLogin();

//  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  const LoginForm({Key? key, required UserRepository userRepository})
      : userRepository = userRepository,
        super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late int rebuild;
  late LoginBloc _loginBloc;

  UserRepository get userRepository => widget.userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated;
  }

  @override
  void initState() {
    super.initState();
    rebuild = 0;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Logging In...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    const Text("Please login or create a account"),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Email',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autocorrect: false,
                      validator: (_) {
                        return state.isEmailValid ? 'Invalid Email' : null;
                      },
                      cursorColor: Colors.black,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Password',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
                        return state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
                      cursorColor: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.white,
                                // onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: isLoginButtonEnabled(state) ? () => _onFormSubmitted() : null,
                              child: const Text('Login'),
                            ),
                          ]),
                    ),
                    CreateAccountButton(userRepository: userRepository),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  _onFormSubmitted() {
    _loginBloc.add(
      LoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
