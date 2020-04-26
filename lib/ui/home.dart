import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import 'dashboard.dart';
import 'login/login.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        print(state);
        if (state is AuthInitial) {
          BlocProvider.of<AuthBloc>(context).add(LoadAuth());

          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AuthLoaded) {
          return !state.loggedIn
              ? LoginScreen(
                  title: widget.title,
                )
              : Dashboard(
                  title: widget.title,
                );
        }

        if (state is AuthCompleted) {
          return Dashboard(
            title: widget.title,
          );
        }

        // TODO: Replace this with a `somethingWentWrong` screen.
        return Container();
      },
    );
  }
}
