import 'package:equatable/equatable.dart';

class VibrationPatternState extends Equatable {
  final String triggerWord;
  final List<int> pattern;

  const VibrationPatternState({
    this.triggerWord = '',
    this.pattern = const [],
  });

  VibrationPatternState copyWith({
    String? triggerWord,
    List<int>? pattern,
  }) {
    return VibrationPatternState(
      triggerWord: triggerWord ?? this.triggerWord,
      pattern: pattern ?? this.pattern,
    );
  }

  @override
  List<Object> get props => [triggerWord, pattern];
}
