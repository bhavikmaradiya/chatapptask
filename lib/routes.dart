import 'package:chatapp/views/auth/authentication.dart';
import 'package:chatapp/views/auth/bloc/auth_bloc.dart';
import 'package:chatapp/views/home/bloc/home_bloc.dart';
import 'package:chatapp/views/home/home.dart';
import 'package:chatapp/views/splash/bloc/splash_bloc.dart';
import 'package:chatapp/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String authentication = '/authentication';

  static Map<String, WidgetBuilder> get routeList => {
        splash: (_) => BlocProvider(
              create: (_) => SplashBloc(),
              child: const Splash(),
            ),
        authentication: (_) => BlocProvider(
              create: (_) => AuthBloc(),
              child: Authentication(),
            ),
        home: (_) => BlocProvider(
              create: (_) => HomeBloc(),
              child: const Home(),
            )
      };
}
