part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  final String email;
  final String name;
  final String photo;

  ProfileUpdateEvent({
    required this.email,
    required this.name,
    required this.photo,
  });
}
