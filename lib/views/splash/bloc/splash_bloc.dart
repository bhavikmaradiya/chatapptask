import 'dart:async';

import 'package:chatapp/config/app_config.dart';
import 'package:chatapp/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final _firebaseAuth = FirebaseAuth.instance;

  SplashBloc() : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onInit);
    add(SplashInitialEvent());
  }

  Future<void> _onInit(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: AppConfig.splashDuration));
    if (_firebaseAuth.currentUser != null) {
      emit(SplashNavigationState(Routes.home));
    } else {
      emit(SplashNavigationState(Routes.authentication));
    }
  }
}
