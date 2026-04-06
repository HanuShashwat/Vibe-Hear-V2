import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object> get props => [];
}

class NavigateToTab extends NavEvent {
  final int tabIndex;

  const NavigateToTab(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
