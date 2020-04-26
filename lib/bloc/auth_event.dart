part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoadAuth extends AuthEvent {}

class LoggedInEvent extends AuthEvent {}
