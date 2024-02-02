part of 'room_bloc.dart';

abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomListUpdated extends RoomState {
  final List<Room> roomList;

  RoomListUpdated(this.roomList);
}
