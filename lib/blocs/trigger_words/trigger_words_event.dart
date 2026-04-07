import 'package:equatable/equatable.dart';

abstract class TriggerWordsEvent extends Equatable {
  const TriggerWordsEvent();

  @override
  List<Object> get props => [];
}

class LoadTriggerWords extends TriggerWordsEvent {}

class AddTriggerWord extends TriggerWordsEvent {
  final String word;
  const AddTriggerWord(this.word);

  @override
  List<Object> get props => [word];
}

class DeleteTriggerWord extends TriggerWordsEvent {
  final String word;
  const DeleteTriggerWord(this.word);

  @override
  List<Object> get props => [word];
}

class ToggleTriggerWord extends TriggerWordsEvent {
  final String word;
  final bool isEnabled;
  
  const ToggleTriggerWord(this.word, this.isEnabled);

  @override
  List<Object> get props => [word, isEnabled];
}
