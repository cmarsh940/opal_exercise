part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthState {
  final String id;

  Authenticated(this.id);

  @override
  String toString() => 'Authenticated { client: $id }';
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';
}

class Loading extends AuthState {
  @override
  String toString() => 'AuthenticationLoading';
}

class UserProfile extends AuthState {
  final user;

  UserProfile(this.user);

  @override
  String toString() => 'UserProfile { user: $user }';
}


