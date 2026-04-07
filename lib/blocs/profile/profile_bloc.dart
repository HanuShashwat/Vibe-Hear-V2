import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final firstName = prefs.getString('firstName') ?? '';
    final middleName = prefs.getString('middleName') ?? '';
    final lastName = prefs.getString('lastName') ?? '';
    final nickName = prefs.getString('nickName') ?? '';

    emit(state.copyWith(
      isLoading: false,
      isFirstTime: isFirstTime,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      nickName: nickName,
    ));
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('firstName', event.firstName);
    await prefs.setString('middleName', event.middleName);
    await prefs.setString('lastName', event.lastName);
    await prefs.setString('nickName', event.nickName);
    await prefs.setBool('isFirstTime', false);

    emit(state.copyWith(
      isFirstTime: false,
      firstName: event.firstName,
      middleName: event.middleName,
      lastName: event.lastName,
      nickName: event.nickName,
    ));
  }
}
