import 'package:equatable/equatable.dart';

class SpeechState extends Equatable {
  final bool isListening;
  final bool isMicAvailable;
  final String detectionMessage;

  const SpeechState({
    this.isListening = false,
    this.isMicAvailable = false,
    this.detectionMessage = 'Initializing...',
  });

  SpeechState copyWith({
    bool? isListening,
    bool? isMicAvailable,
    String? detectionMessage,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      isMicAvailable: isMicAvailable ?? this.isMicAvailable,
      detectionMessage: detectionMessage ?? this.detectionMessage,
    );
  }

  @override
  List<Object> get props => [isListening, isMicAvailable, detectionMessage];
}
