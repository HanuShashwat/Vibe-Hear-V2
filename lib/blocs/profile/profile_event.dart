import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final String firstName;
  final String middleName;
  final String lastName;
  final String nickName;

  const SaveProfile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.nickName,
  });

  @override
  List<Object> get props => [firstName, middleName, lastName, nickName];
}
