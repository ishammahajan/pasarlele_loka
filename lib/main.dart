import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = 'Pasarlele Loka';

    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Home(title: title),
      ),
    );
  }
}
