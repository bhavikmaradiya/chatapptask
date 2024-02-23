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

  final _roomList = <Room>[];

  RoomBloc() : super(RoomInitialState()) {
    on<ListenRoomChangesEvent>(_startRoomChangeListener);
  }

  Future<void> _startRoomChangeListener(
    ListenRoomChangesEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoadingState());
    final snapshotStream = await _getMyRoomsSnapshot();
    _roomListSubscription = snapshotStream.listen((snapshot) async {
      await _updateRoomInfo(snapshot);
      if (_roomList.isEmpty) {
        emit(RoomListEmptyState());
      } else {
        emit(RoomListUpdatedState(_roomList));
      }
    });
    await _roomListSubscription?.asFuture();
  }

  Future<void> _updateRoomInfo(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    if (snapshot.docChanges.isNotEmpty) {
      for (final element in snapshot.docChanges) {
        final document = element.doc;
        if (element.type == DocumentChangeType.added) {
          _addNewRoom(document);
        } else if (element.type == DocumentChangeType.modified) {
          _modifyRoomDetails(document);
        } else if (element.type == DocumentChangeType.removed) {
          _removeRoom(document);
        }
      }
    }
  }

  void _addNewRoom(DocumentSnapshot document) {
    try {
      final roomInfo = Room.fromSnapshot(document);
      _roomList.add(roomInfo);
    } on Exception catch (_) {}
  }

  void _modifyRoomDetails(DocumentSnapshot document) {
    final index = _roomList.indexWhere(
      (roomInfo) => roomInfo.roomId == document.id,
    );
    if (index != (-1)) {
      try {
        final roomInfo = Room.fromSnapshot(document);
        _roomList[index] = roomInfo;
      } on Exception catch (_) {}
    }
  }

  void _removeRoom(DocumentSnapshot document) {
    _roomList.removeWhere(
      (roomInfo) => roomInfo.roomId == document.id,
    );
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
