import 'package:equatable/equatable.dart';

abstract class VibrationPatternEvent extends Equatable {
  const VibrationPatternEvent();

  @override
  List<Object> get props => [];
}

class LoadPattern extends VibrationPatternEvent {
  final String triggerWord;
  const LoadPattern(this.triggerWord);

  @override
  List<Object> get props => [triggerWord];
}

class AddDuration extends VibrationPatternEvent {
  final int duration;
  const AddDuration(this.duration);

  @override
  List<Object> get props => [duration];
}

class ResetPattern extends VibrationPatternEvent {}

class SavePattern extends VibrationPatternEvent {}

class TestPattern extends VibrationPatternEvent {}
