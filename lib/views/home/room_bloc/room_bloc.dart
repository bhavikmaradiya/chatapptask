import 'dart:async';

import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/config/preference_config.dart';
import 'package:chatapp/views/auth/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'room_event.dart';

part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final _fireStoreInstance = FirebaseFirestore.instance;
  StreamSubscription? _roomListSubscription;

  final roomList = <Room>[];

  RoomBloc() : super(RoomInitial()) {
    on<ListenRoomChangesEvent>(_startRoomChangeListener);
  }

  Future<void> _startRoomChangeListener(
    ListenRoomChangesEvent event,
    Emitter<RoomState> emit,
  ) async {
    final snapshotStream = await _getMyRoomsSnapshot();
    _roomListSubscription = snapshotStream.listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        for (final element in snapshot.docChanges) {
          final document = element.doc;
          if (element.type == DocumentChangeType.added) {
          } else if (element.type == DocumentChangeType.modified) {
          } else if (element.type == DocumentChangeType.removed) {}
        }
      }
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      _getMyRoomsSnapshot() async {
    final userId = await _getCurrentUserId();
    return _fireStoreInstance
        .collection(FireStoreConfig.roomCollection)
        .where(
          FireStoreConfig.roomMemberIdsField,
          arrayContains: userId,
        )
        .orderBy(
          FireStoreConfig.updatedAtField,
          descending: true,
        )
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> buildStreamOfUser(
    String userId,
  ) {
    return _fireStoreInstance
        .collection(FireStoreConfig.userCollection)
        .doc(userId)
        .snapshots();
  }

  Future<String?> _getCurrentUserId() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceConfig.userIdPref);
  }
}
