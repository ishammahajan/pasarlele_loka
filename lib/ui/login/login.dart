import 'package:flutter/material.dart';

import 'email_login_form.dart';
import 'google_login_form.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.home,
              size: 125.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          EmailLoginForm(),
          GoogleLoginForm(),
        ],
      ),
    );
  }
}
