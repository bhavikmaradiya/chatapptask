part of 'room_bloc.dart';

abstract class RoomState {}

class RoomInitialState extends RoomState {}

class RoomListUpdatedState extends RoomState {
  final List<Room> roomList;

  RoomListUpdatedState(this.roomList);
}

class RoomLoadingState extends RoomState {
  RoomLoadingState();
}

class RoomListEmptyState extends RoomState {
  RoomListEmptyState();
}
