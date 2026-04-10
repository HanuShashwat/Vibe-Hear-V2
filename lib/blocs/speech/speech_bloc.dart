import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/background_service.dart';
import '../trigger_words/trigger_words_bloc.dart';
import 'speech_event.dart';
import 'speech_state.dart';

class _SyncServiceState extends SpeechEvent {
  final bool isListening;
  final List<String> history;
  const _SyncServiceState(this.isListening, this.history);
  @override
  List<Object> get props => [isListening, history];
}

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final TriggerWordsBloc triggerWordsBloc;
  StreamSubscription? _serviceSubscription;

  SpeechBloc({required this.triggerWordsBloc}) : super(const SpeechState()) {
    on<InitializeSpeech>(_onInitialize);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<ToggleListening>(_onToggleListening);
    on<UpdateMessage>(_onUpdateMessage);
    on<UpdateTranscript>(_onUpdateTranscript);
    on<FinalizeTranscript>(_onFinalizeTranscript);
    on<_SyncServiceState>((event, emit) {
      emit(state.copyWith(
        isListening: event.isListening,
        transcriptHistory: event.history,
      ));
    });
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    return super.close();
  }

  Future<void> _onInitialize(
      InitializeSpeech event, Emitter<SpeechState> emit) async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      emit(state.copyWith(isMicAvailable: true));
      await initializeBackgroundService();
      
      _serviceSubscription = FlutterBackgroundService().on('update').listen((event) {
        if (event != null && !isClosed) {
           final isListening = event['isListening'] as bool? ?? false;
           final message = event['message'] as String? ?? '';
           final currentTranscript = event['currentTranscript'] as String? ?? '';
           final historyRaw = event['history'] as List<dynamic>? ?? [];
           final history = historyRaw.map((e) => e.toString()).toList();
           
           add(UpdateTranscript(currentTranscript, isFinal: false));
           add(UpdateMessage(message));
           add(_SyncServiceState(isListening, history));
        }
      });
      
    } else if (status.isPermanentlyDenied) {
      emit(state.copyWith(
          isMicAvailable: false,
          detectionMessage: "Microphone permission denied.\nPlease check settings."));
      await openAppSettings();
    } else {
      emit(state.copyWith(
          isMicAvailable: false,
          detectionMessage: "Microphone permission required."));
    }
  }

  void _onStartListening(StartListening event, Emitter<SpeechState> emit) async {
    if (!state.isMicAvailable) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_muted', false);
    emit(state.copyWith(isPaused: false));
  }

  void _onStopListening(StopListening event, Emitter<SpeechState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_muted', true);
    emit(state.copyWith(isPaused: true));
  }

  void _onToggleListening(ToggleListening event, Emitter<SpeechState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isMuted = prefs.getBool('is_muted') ?? false;
    await prefs.setBool('is_muted', !isMuted);
    emit(state.copyWith(isPaused: !isMuted));
  }

  void _onUpdateMessage(UpdateMessage event, Emitter<SpeechState> emit) {
    emit(state.copyWith(detectionMessage: event.message));
  }

  void _onUpdateTranscript(UpdateTranscript event, Emitter<SpeechState> emit) {
    emit(state.copyWith(currentTranscript: event.currentWords));
  }

  void _onFinalizeTranscript(FinalizeTranscript event, Emitter<SpeechState> emit) {
    // Handled by background service isolate passing synced history
  }
}
