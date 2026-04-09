import 'package:equatable/equatable.dart';

abstract class SpeechEvent extends Equatable {
  const SpeechEvent();

  @override
  List<Object> get props => [];
}

class InitializeSpeech extends SpeechEvent {}

class StartListening extends SpeechEvent {}

class StopListening extends SpeechEvent {}

class UpdateMessage extends SpeechEvent {
  final String message;
  const UpdateMessage(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateTranscript extends SpeechEvent {
  final String currentWords;
  final bool isFinal;

  const UpdateTranscript(this.currentWords, {this.isFinal = false});

  @override
  List<Object> get props => [currentWords, isFinal];
}

class FinalizeTranscript extends SpeechEvent {}

class ToggleListening extends SpeechEvent {}
