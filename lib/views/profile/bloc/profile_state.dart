part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User profileInfo;

  ProfileLoadedState(this.profileInfo);
}
