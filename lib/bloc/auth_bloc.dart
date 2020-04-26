import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/firebase/user/current_user_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class Auth {
  static bool loading;
  static bool loggedIn;

  static String username;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoadAuth) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      yield AuthLoaded(preferences.getBool('LoggedIn') ?? false);
    }

    if (event is LoggedInEvent) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await saveCurrentUser(User.fromFirebaseUser(user));

      yield AuthCompleted();
    }
  }
}
