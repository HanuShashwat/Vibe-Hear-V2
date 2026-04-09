import 'package:equatable/equatable.dart';

class SpeechState extends Equatable {
  final bool isListening;
  final bool isMicAvailable;
  final bool isPaused;
  final String detectionMessage;
  final List<String> transcriptHistory;
  final String currentTranscript;

  const SpeechState({
    this.isListening = false,
    this.isMicAvailable = false,
    this.isPaused = false,
    this.detectionMessage = 'Initializing...',
    this.transcriptHistory = const [],
    this.currentTranscript = '',
  });

  SpeechState copyWith({
    bool? isListening,
    bool? isMicAvailable,
    bool? isPaused,
    String? detectionMessage,
    List<String>? transcriptHistory,
    String? currentTranscript,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      isMicAvailable: isMicAvailable ?? this.isMicAvailable,
      isPaused: isPaused ?? this.isPaused,
      detectionMessage: detectionMessage ?? this.detectionMessage,
      transcriptHistory: transcriptHistory ?? this.transcriptHistory,
      currentTranscript: currentTranscript ?? this.currentTranscript,
    );
  }

  @override
  List<Object> get props => [isListening, isMicAvailable, isPaused, detectionMessage, transcriptHistory, currentTranscript];
}
