import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../trigger_words/trigger_words_bloc.dart';
import 'speech_event.dart';
import 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final TriggerWordsBloc triggerWordsBloc;
  final stt.SpeechToText _speech = stt.SpeechToText();
  DateTime _lastDetectionTime = DateTime.now();
  DateTime _lastFinalizeTime = DateTime.now();

  SpeechBloc({required this.triggerWordsBloc}) : super(const SpeechState()) {
    on<InitializeSpeech>(_onInitialize);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<ToggleListening>(_onToggleListening);
    on<UpdateMessage>(_onUpdateMessage);
    on<UpdateTranscript>(_onUpdateTranscript);
    on<FinalizeTranscript>(_onFinalizeTranscript);
  }

  Future<void> _onInitialize(
      InitializeSpeech event, Emitter<SpeechState> emit) async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      final available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'notListening' || val == 'done') {
            if (!isClosed) {
              add(FinalizeTranscript());
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!isClosed) add(StartListening());
              });
            }
          }
        },
        onError: (err) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!isClosed) {
              add(FinalizeTranscript());
              add(StartListening());
            }
          });
        },
      );
      if (available) {
        emit(state.copyWith(isMicAvailable: true));
        add(StartListening());
      } else {
        emit(state.copyWith(
            isMicAvailable: false,
            detectionMessage: "Speech mode unavailable."));
      }
    } else if (status.isPermanentlyDenied) {
      emit(state.copyWith(
          isMicAvailable: false,
          detectionMessage: "Microphone permssion denied.\nPlease check settings."));
      await openAppSettings();
    } else {
      emit(state.copyWith(
          isMicAvailable: false,
          detectionMessage: "Microphone permission required."));
    }
  }

  Future<void> _onStartListening(
      StartListening event, Emitter<SpeechState> emit) async {
    if (!_speech.isAvailable || state.isMicAvailable == false || state.isPaused) return;
    
    // Force a cleanup if it thinks it's already listening to prevent permanent hang
    if (_speech.isListening) {
      await _speech.cancel();
      await Future.delayed(const Duration(milliseconds: 100)); // Brief pause to let native channels clear
    }

    emit(state.copyWith(isListening: true, detectionMessage: 'Actively listening...'));

    try {
      await _speech.listen(
        onResult: (result) {
          add(UpdateTranscript(result.recognizedWords, isFinal: result.finalResult));
          final recognizedWords = result.recognizedWords.toLowerCase();
          for (final trigger in triggerWordsBloc.state.triggerWords) {
            if (triggerWordsBloc.state.enabledStatus[trigger] == true &&
                recognizedWords.contains(trigger.toLowerCase())) {
              if (DateTime.now().difference(_lastDetectionTime).inSeconds > 2) {
                _lastDetectionTime = DateTime.now();
                _handleDetection(trigger);
              }
            }
          }
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.dictation,
        ),
      );
    } catch (e) {
      // In case of platform exception, ensure we recover gracefully.
      emit(state.copyWith(
          isListening: false, detectionMessage: "Mic error, restarting..."));
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!isClosed) add(StartListening());
      });
    }
  }

  void _onStopListening(StopListening event, Emitter<SpeechState> emit) {
    _speech.stop();
    add(FinalizeTranscript());
    emit(state.copyWith(isListening: false));
  }

  void _onToggleListening(ToggleListening event, Emitter<SpeechState> emit) {
    if (state.isPaused) {
      emit(state.copyWith(isPaused: false));
      add(StartListening());
    } else {
      emit(state.copyWith(isPaused: true));
      _speech.stop();
      add(FinalizeTranscript());
    }
  }

  void _onUpdateMessage(UpdateMessage event, Emitter<SpeechState> emit) {
    emit(state.copyWith(detectionMessage: event.message));
  }

  void _onUpdateTranscript(UpdateTranscript event, Emitter<SpeechState> emit) {
    if (event.isFinal && event.currentWords.isNotEmpty) {
      final newHistory = List<String>.from(state.transcriptHistory);
      final now = DateTime.now();

      if (newHistory.isEmpty || now.difference(_lastFinalizeTime).inSeconds > 3) {
        newHistory.add(event.currentWords);
      } else {
        newHistory[newHistory.length - 1] = newHistory.last + " " + event.currentWords;
      }

      _lastFinalizeTime = now;
      
      emit(state.copyWith(
        transcriptHistory: newHistory,
        currentTranscript: '',
      ));
    } else {
      emit(state.copyWith(currentTranscript: event.currentWords));
    }
  }

  void _onFinalizeTranscript(FinalizeTranscript event, Emitter<SpeechState> emit) {
    if (state.currentTranscript.isNotEmpty) {
      final newHistory = List<String>.from(state.transcriptHistory);
      final now = DateTime.now();

      if (newHistory.isEmpty || now.difference(_lastFinalizeTime).inSeconds > 3) {
        newHistory.add(state.currentTranscript);
      } else {
        newHistory[newHistory.length - 1] = newHistory.last + " " + state.currentTranscript;
      }

      _lastFinalizeTime = now;

      emit(state.copyWith(
        transcriptHistory: newHistory,
        currentTranscript: '',
      ));
    }
  }

  Future<void> _handleDetection(String triggerWord) async {
    add(UpdateMessage('Detected: $triggerWord'));

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList("vibration_$triggerWord") ?? [];
    final pattern = raw.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();

    if (await Vibration.hasVibrator() == true) {
      if (pattern.isNotEmpty) {
        final withPauses = [0];
        for (final ms in pattern) {
          withPauses.add(ms);
          withPauses.add(150);
        }
        withPauses.removeLast();
        Vibration.vibrate(pattern: withPauses);
      } else {
        Vibration.vibrate(pattern: [0, 500, 150, 500]);
      }
    }

    Future.delayed(const Duration(seconds: 4), () {
      if (!isClosed) {
        if (_speech.isListening) {
           add(UpdateMessage('Actively listening...'));
        } else {
           add(StartListening());
        }
      }
    });
  }
}
