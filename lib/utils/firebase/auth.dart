import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user/update_profile.dart';

enum AuthMode { GOOGLE, EMAIL }

enum AuthResultStatus {
  COMPLETED,
  WRONG_PASSWORD,
  NO_USER_FOUND,
}

Future<AuthResultStatus> authenticate(
  AuthMode mode, {
  String email,
  String password,
  String displayName,
}) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  switch (mode) {
    case AuthMode.EMAIL:
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result.user != null) {
          return AuthResultStatus.COMPLETED;
        }
      } catch (exception) {
        if (exception is PlatformException) {
          if (exception.code == 'ERROR_USER_NOT_FOUND') {
            if (displayName == null) {
              return AuthResultStatus.NO_USER_FOUND;
            }

            final FirebaseUser user =
                (await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ))
                    .user;

            if (await setDisplayName(user, displayName)) {
              return AuthResultStatus.COMPLETED;
            }
          } else if (exception.code == 'ERROR_WRONG_PASSWORD')
            return AuthResultStatus.WRONG_PASSWORD;
        }
      }

      return null;
      break;

    case AuthMode.GOOGLE:
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("[Firebase Auth] Signed In: " + user.displayName);
      return AuthResultStatus.COMPLETED;
      break;

    default:
      print('***** Authentication Mode not selected! *****');
      return null;
      break;
  }
}
