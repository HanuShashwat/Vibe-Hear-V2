import 'package:equatable/equatable.dart';

class TriggerWordsState extends Equatable {
  final List<String> triggerWords;
  final Map<String, bool> enabledStatus;

  const TriggerWordsState({
    this.triggerWords = const [],
    this.enabledStatus = const {},
  });

  TriggerWordsState copyWith({
    List<String>? triggerWords,
    Map<String, bool>? enabledStatus,
  }) {
    return TriggerWordsState(
      triggerWords: triggerWords ?? this.triggerWords,
      enabledStatus: enabledStatus ?? this.enabledStatus,
    );
  }

  @override
  List<Object> get props => [triggerWords, enabledStatus];
}
