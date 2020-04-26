import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/auth_bloc.dart';
import '../../utils/firebase/auth.dart';

class GoogleLoginForm extends StatefulWidget {
  @override
  _GoogleLoginFormState createState() => _GoogleLoginFormState();
}

class _GoogleLoginFormState extends State<GoogleLoginForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Text(
                'or',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: SvgPicture.asset(
                "assets/images/btn_google_light_normal_ios.svg",
                height: 50,
              ),
              color: Colors.white,
              onPressed: () async {
                FirebaseUser user = await authenticate(AuthMode.GOOGLE);
                BlocProvider.of<AuthBloc>(context).add(LoggedInEvent());
              },
            ),
          ),
        ],
      ),
    );
  }
}
