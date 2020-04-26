part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthCompleted extends AuthState {}

class AuthLoaded extends AuthState {
  bool loggedIn;

  AuthLoaded(this.loggedIn);
}
