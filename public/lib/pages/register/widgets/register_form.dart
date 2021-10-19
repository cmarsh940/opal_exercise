import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public/auth/auth_bloc.dart';


import '../register.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Container(
            width: 450,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email,
                          color: Colors.grey,
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      autocorrect: false,
                      validator: (_) {
                        return state.isEmailValid ? 'Invalid Email' : null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                      child: Text(
                        '8 charactors, 1 upper case and atleast 1 number.',
                        style: TextStyle(
                          fontSize: 8, 
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock,
                          color: Colors.grey,
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
                        return state.isPasswordValid ? 'Invalid Password' : null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        labelText: 'Confirm Password', 
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
                        return state.passwordsMatch ? 'Passwords dont match' : null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: isRegisterButtonEnabled(state) ? () => _onFormSubmitted() : null,
                        child: const Text('Register'),
                      ),
                    ),
                    
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
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }
  void _onConfirmPasswordChanged() {
    _registerBloc.add(
      ConfirmPasswordChanged(password: _passwordController.text, confirmPassword: _confirmPasswordController.text),
    );
  }

  _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPass: _confirmPasswordController.text
      ),
    );
  }
}