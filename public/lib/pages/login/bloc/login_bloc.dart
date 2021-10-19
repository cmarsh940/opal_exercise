import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:public/data/repositories.dart';

import '../../../shared/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository, super(LoginState.loading());

  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginButtonPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    yield LoginState.loading();
    
    var response =  await _userRepository.authenticate(
      email: email,
      password: password,
    );

    if (response != null) {
      yield LoginState.success();
    } else {
      yield LoginState.failure();
    }
  }

}