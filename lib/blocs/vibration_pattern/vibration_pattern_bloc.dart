import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'vibration_pattern_event.dart';
import 'vibration_pattern_state.dart';

class VibrationPatternBloc extends Bloc<VibrationPatternEvent, VibrationPatternState> {
  VibrationPatternBloc() : super(const VibrationPatternState()) {
    on<LoadPattern>(_onLoadPattern);
    on<AddDuration>(_onAddDuration);
    on<ResetPattern>(_onResetPattern);
    on<SavePattern>(_onSavePattern);
    on<TestPattern>(_onTestPattern);
  }

  Future<void> _onLoadPattern(LoadPattern event, Emitter<VibrationPatternState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("vibration_${event.triggerWord}");
    
    List<int> pattern = [];
    if (saved != null) {
      pattern = saved.map(int.parse).toList();
    }
    
    emit(state.copyWith(triggerWord: event.triggerWord, pattern: pattern));
  }

  void _onAddDuration(AddDuration event, Emitter<VibrationPatternState> emit) {
    if (event.duration <= 0) return;
    final updated = List<int>.from(state.pattern)..add(event.duration);
    emit(state.copyWith(pattern: updated));
  }

  void _onResetPattern(ResetPattern event, Emitter<VibrationPatternState> emit) {
    emit(state.copyWith(pattern: []));
  }

  Future<void> _onSavePattern(SavePattern event, Emitter<VibrationPatternState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "vibration_${state.triggerWord}",
      state.pattern.map((e) => e.toString()).toList(),
    );
    // In a full app, we might emit a "Saved" state momentarily to show a snackbar in the UI.
  }

  Future<void> _onTestPattern(TestPattern event, Emitter<VibrationPatternState> emit) async {
    final supported = await Vibration.hasVibrator();
    if (supported == true && state.pattern.isNotEmpty) {
      final formattedPattern = [0];
      for (final ms in state.pattern) {
        formattedPattern.add(ms);
        formattedPattern.add(150);
      }
      formattedPattern.removeLast();

      Vibration.vibrate(pattern: formattedPattern);
    }
  }
}
