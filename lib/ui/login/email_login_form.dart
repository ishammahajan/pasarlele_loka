import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../utils/firebase/auth.dart';

class EmailLoginForm extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  EmailLoginForm(this.scaffoldKey);

  @override
  _EmailLoginFormState createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  bool isSignup = false;

  final _formKey = GlobalKey<FormState>();

  final _emailKey = GlobalKey<FormFieldState>();
  final _displayNameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

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
              child: RichText(
                text: TextSpan(
                  text: 'Welcome, proceed with your ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                  children: [
                    TextSpan(
                      text: 'login',
                      style: TextStyle(
                        color: isSignup
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyText1.color,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('tapped login');
                          setState(() {
                            isSignup = false;
                          });
                        },
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    TextSpan(
                      text: 'signup',
                      style: TextStyle(
                        color: isSignup
                            ? Theme.of(context).textTheme.bodyText1.color
                            : Theme.of(context).primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('tapped signup');
                          setState(() {
                            isSignup = true;
                          });
                        },
                    ),
                  ],
                ),
              ),
              // child: Text(
              //   'Welcome, proceed with your login / signup',
              //   textScaleFactor: 1.2,
              // ),
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
                key: _emailKey,
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

                  if (!matcher.hasMatch(value.trim())) {
                    return 'Please enter a valid email id';
                  }

                  return null;
                },
              ),
            ),
            isSignup
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: _displayNameKey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Display Name',
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _passwordKey,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
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
                      AuthResultStatus result = await authenticate(
                        AuthMode.EMAIL,
                        email: _emailKey.currentState.value.trim(),
                        password: _passwordKey.currentState.value,
                        displayName: _displayNameKey.currentState == null
                            ? null
                            : _displayNameKey.currentState.value == ''
                                ? null
                                : _displayNameKey.currentState.value,
                      ).timeout(Duration(seconds: 5), onTimeout: () => null);

                      if (result == AuthResultStatus.NO_USER_FOUND) {
                        widget.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              'If this is your first time, please signup instead...',
                            ),
                          ),
                        );
                      }

                      if (result == AuthResultStatus.WRONG_PASSWORD) {
                        widget.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Wrong username or password...',
                            ),
                          ),
                        );
                      }

                      if (result == AuthResultStatus.COMPLETED) {
                        BlocProvider.of<AuthBloc>(context).add(LoggedInEvent());
                      }

                      if (result == null) {
                        widget.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Having difficulty accessing servers...',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: GestureDetector(
                onTap: () async {
                  if (_emailKey.currentState.value == '') {
                    widget.scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter your email in the field...',
                        ),
                      ),
                    );
                  }

                  bool sentEmail =
                      await resetPassword(_emailKey.currentState.value.trim())
                          .timeout(
                    Duration(seconds: 5),
                    onTimeout: () => false,
                  );

                  if (sentEmail) {
                    widget.scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please check your email for a password reset link...',
                        ),
                      ),
                    );
                  } else {
                    widget.scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Difficulty accessing servers...',
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Forgot Password',
                  textScaleFactor: 0.75,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
