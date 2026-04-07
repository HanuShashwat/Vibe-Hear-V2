import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isFirstTime;
  final String firstName;
  final String middleName;
  final String lastName;
  final String nickName;

  const ProfileState({
    this.isLoading = true,
    this.isFirstTime = true,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.nickName = '',
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isFirstTime,
    String? firstName,
    String? middleName,
    String? lastName,
    String? nickName,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      nickName: nickName ?? this.nickName,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        isFirstTime,
        firstName,
        middleName,
        lastName,
        nickName,
      ];
}
