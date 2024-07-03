import 'dart:async';

import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/config/preference_config.dart';
import 'package:chatapp/views/auth/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  final _fireStoreInstance = FirebaseFirestore.instance;

  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileInitialEvent>(_fetchProfile);
    on<ProfileUpdateEvent>(_saveProfileInfo);
    add(ProfileInitialEvent());
  }

  Future<void> _fetchProfile(
    ProfileInitialEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    final prefs = await SharedPreferences.getInstance();
    final isFirstLogin =
        prefs.getBool(PreferenceConfig.isFirstSignInPref) ?? true;
    User? profileInfo;
    if (!isFirstLogin) {
      profileInfo = await _fetchProfileInfoFromFirebase();
    }
    profileInfo ??= User(
      userId: prefs.getString(PreferenceConfig.userIdPref),
      name: prefs.getString(PreferenceConfig.userNamePref),
      email: prefs.getString(PreferenceConfig.userEmailPref),
      photo: prefs.getString(PreferenceConfig.userPhotoPref),
    );
    emit(ProfileLoadedState(profileInfo));
  }

  Future<void> _saveProfileInfo(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    final data = <String, dynamic>{};
    final prefs = await SharedPreferences.getInstance();
    final isFirstLogin =
        prefs.getBool(PreferenceConfig.isFirstSignInPref) ?? true;
    final firebaseUserId = prefs.getString(PreferenceConfig.userIdPref);
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    data[FireStoreConfig.userNameField] = event.name;
    data[FireStoreConfig.userEmailField] = event.email;
    data[FireStoreConfig.userPhotoField] = event.photo;
    data[FireStoreConfig.userIdField] = firebaseUserId;
    data[FireStoreConfig.updatedAtField] = createdAt;
    if (isFirstLogin) {
      data[FireStoreConfig.createdAtField] = createdAt;
      await FirebaseFirestore.instance
          .collection(FireStoreConfig.userCollection)
          .doc(firebaseUserId)
          .set(data);
      await prefs.setBool(
        PreferenceConfig.isFirstSignInPref,
        false,
      );
    } else {
      await FirebaseFirestore.instance
          .collection(FireStoreConfig.userCollection)
          .doc(firebaseUserId)
          .update(data);
    }
    emit(ProfileUpdatedState());
  }

  Future<User?> _fetchProfileInfoFromFirebase() async {
    final user = await _fireStoreInstance
        .collection(FireStoreConfig.userCollection)
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    User? profileInfo;
    try {
      profileInfo = User.fromSnapshot(user);
    } on Exception catch (_) {}
    return profileInfo;
  }
}
