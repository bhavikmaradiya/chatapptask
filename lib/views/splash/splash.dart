import 'package:chatapp/views/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (prev, current) =>
          prev != current && current is! SplashInitialState,
      listener: (context, state) {
        if (state is SplashNavigationState) {
          Navigator.pushReplacementNamed(context, state.route);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }
}
