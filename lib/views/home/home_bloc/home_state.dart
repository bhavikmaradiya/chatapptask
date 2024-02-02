part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class UserInfoUpdatedState extends HomeState {
  final User user;

  UserInfoUpdatedState(this.user);
}
