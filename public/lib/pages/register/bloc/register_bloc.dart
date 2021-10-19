import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:public/data/repositories.dart';

import '../../../shared/validators.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository, super(RegisterState.loading());

  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is ConfirmPasswordChanged) {
      yield* _mapConfirmPasswordChangedToState(
          event.password, event.confirmPassword);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password, event.confirmPass);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapConfirmPasswordChangedToState(
      String confirmPassword, String password) async* {
    yield state.update(
      passwordsMatch: Validators.passwordsMatch(password, confirmPassword),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
    String confirmPass,
  ) async* {
    yield RegisterState.loading();
    var response = await _userRepository.signUp(
      email: email,
      password: password,
      confirmPass: confirmPass,
    );
    if (response != null) {
      yield RegisterState.success();
    } else {
      yield RegisterState.failure();
    }
  }
}