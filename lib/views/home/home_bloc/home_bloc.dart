import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/config/preference_config.dart';
import 'package:chatapp/views/auth/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _fireStoreInstance = FirebaseFirestore.instance;

  HomeBloc() : super(HomeInitial()) {
    on<FetchCurrentUserInfo>(_getCurrentUserInfo);
  }

  Future<void> _getCurrentUserInfo(
    FetchCurrentUserInfo event,
    Emitter<HomeState> emit,
  ) async {
    final userId = await _getCurrentUserId();
    final doc = await _fireStoreInstance
        .collection(FireStoreConfig.userCollection)
        .doc(userId)
        .get();
    try {
      final user = User.fromSnapshot(doc);
      emit(UserInfoUpdatedState(user));
    } catch (e) {}
  }

  Future<String?> _getCurrentUserId() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceConfig.userIdPref);
  }
}
