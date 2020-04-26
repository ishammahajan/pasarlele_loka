import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../utils/firebase/auth.dart';

class EmailLoginForm extends StatefulWidget {
  @override
  _EmailLoginFormState createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome, proceed with your login / signup',
                textScaleFactor: 1.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Using Email',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }

                  RegExp matcher = new RegExp(
                    r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$",
                    caseSensitive: false,
                    multiLine: false,
                  );

                  if (!matcher.hasMatch(value)) {
                    return 'Please enter a valid email id';
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }

                  int lowerCase = 0;
                  int upperCase = 0;
                  int digits = 0;
                  int length = value.runes.length;

                  value.runes.forEach((element) {
                    if (element >= 65 && element <= 90) {
                      upperCase++;
                    }

                    if (element >= 97 && element <= 122) {
                      lowerCase++;
                    }

                    if (element >= 48 && element <= 57) {
                      digits++;
                    }
                  });

                  if (lowerCase == 0) {
                    return 'Enter at least 1 lower case character';
                  }

                  if (upperCase == 0) {
                    return 'Enter at least 1 upper case character';
                  }

                  if (digits == 0) {
                    return 'Enter at least 1 digits';
                  }

                  if (length < 8) {
                    return 'Length should be > 8 characters';
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FirebaseUser user = await authenticate(AuthMode.GOOGLE);
                      BlocProvider.of<AuthBloc>(context).add(LoggedInEvent());
                    }
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
