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

  SpeechBloc({required this.triggerWordsBloc}) : super(const SpeechState()) {
    on<InitializeSpeech>(_onInitialize);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<UpdateMessage>(_onUpdateMessage);
  }

  Future<void> _onInitialize(
      InitializeSpeech event, Emitter<SpeechState> emit) async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      final available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'notListening' || val == 'done') {
            if (!isClosed) add(StartListening()); // continuous loop
          }
        },
        onError: (err) {
          Future.delayed(const Duration(seconds: 1), () {
            if (!isClosed) add(StartListening());
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
    if (!_speech.isAvailable || state.isMicAvailable == false) return;
    if (_speech.isListening) return;

    emit(state.copyWith(isListening: true, detectionMessage: 'Actively listening...'));

    await _speech.listen(
      onResult: (result) {
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
  }

  void _onStopListening(StopListening event, Emitter<SpeechState> emit) {
    _speech.stop();
    emit(state.copyWith(isListening: false));
  }

  void _onUpdateMessage(UpdateMessage event, Emitter<SpeechState> emit) {
    emit(state.copyWith(detectionMessage: event.message));
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
      if (!isClosed) add(StartListening()); // resets status message to 'actively listening'
    });
  }
}
