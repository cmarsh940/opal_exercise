import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:public/data/repositories.dart';
import 'package:public/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepository})
      : _userRepository = userRepository, super(Uninitialized());

  // @override
  // AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is Profile) {
      yield* _mapProfileToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn == null || !isSignedIn) {
        yield Unauthenticated();
      } else {
          final String id = (await _userRepository.getId())!;
          yield Authenticated(id);
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
      yield Authenticated((await _userRepository.getId())!);
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    _userRepository.signOut();
    yield Unauthenticated();
  }

  Stream<AuthState> _mapProfileToState() async* {
    var user = await _userRepository.getUser();
    Map<String, dynamic> userMap = jsonDecode(user);
    final User newUser = User.fromJson(userMap);
    yield UserProfile(newUser);
  }

}
