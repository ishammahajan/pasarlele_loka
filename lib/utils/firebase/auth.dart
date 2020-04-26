import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pasarlele_loka/utils/firebase/database/user_transactions.dart';

enum AuthMode { GOOGLE, EMAIL }

Future<FirebaseUser> authenticate(
  AuthMode mode, {
  String email,
  String password,
}) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  switch (mode) {
    case AuthMode.EMAIL:
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return user;
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
      return user;
      break;

    default:
      print('***** Authentication Mode not selected! *****');
      return null;
      break;
  }
}
