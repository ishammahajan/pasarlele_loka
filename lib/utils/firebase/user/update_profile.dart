import 'package:firebase_auth/firebase_auth.dart';

Future<bool> setDisplayName(FirebaseUser user, String displayName) async {
  UserUpdateInfo updateInfo = UserUpdateInfo();
  updateInfo.displayName = displayName;

  await user.updateProfile(updateInfo);

  FirebaseUser newUser = await FirebaseAuth.instance.currentUser();
  if (newUser.displayName == displayName) {
    return true;
  }

  return false;
}
