import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../models/user.dart';

Future<void> saveCurrentUser(User user) async {
  final storage = new FlutterSecureStorage();
  await storage.write(key: 'current_user', value: user.toString());
}

Future<User> getCurrentUser() async {
  final storage = new FlutterSecureStorage();
  return User.fromString(await storage.read(key: 'current_user'));
}
