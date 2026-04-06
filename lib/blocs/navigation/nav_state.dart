import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int tabIndex;

  const NavState({this.tabIndex = 0});

  @override
  List<Object> get props => [tabIndex];
}
