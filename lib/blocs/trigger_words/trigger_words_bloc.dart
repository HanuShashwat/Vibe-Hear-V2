import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trigger_words_event.dart';
import 'trigger_words_state.dart';

class TriggerWordsBloc extends Bloc<TriggerWordsEvent, TriggerWordsState> {
  TriggerWordsBloc() : super(const TriggerWordsState()) {
    on<LoadTriggerWords>(_onLoad);
    on<AddTriggerWord>(_onAdd);
    on<DeleteTriggerWord>(_onDelete);
    on<ToggleTriggerWord>(_onToggle);
  }

  Future<void> _onLoad(LoadTriggerWords event, Emitter<TriggerWordsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeywords = prefs.getStringList('custom_keywords') ?? ['Emergency', 'Come Here', 'Help Me'];
    
    Map<String, bool> enabled = {};
    for (final word in savedKeywords) {
      enabled[word] = prefs.getBool('enabled_$word') ?? true;
    }

    if (prefs.getStringList('custom_keywords') == null) {
      await prefs.setStringList('custom_keywords', savedKeywords);
    }

    emit(state.copyWith(triggerWords: savedKeywords, enabledStatus: enabled));
  }

  Future<void> _onAdd(AddTriggerWord event, Emitter<TriggerWordsState> emit) async {
    if (state.triggerWords.contains(event.word)) return;

    final updatedWords = List<String>.from(state.triggerWords)..add(event.word);
    final updatedStatus = Map<String, bool>.from(state.enabledStatus)..[event.word] = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_keywords', updatedWords);
    await prefs.setBool('enabled_${event.word}', true);

    emit(state.copyWith(triggerWords: updatedWords, enabledStatus: updatedStatus));
  }

  Future<void> _onDelete(DeleteTriggerWord event, Emitter<TriggerWordsState> emit) async {
    final updatedWords = List<String>.from(state.triggerWords)..remove(event.word);
    final updatedStatus = Map<String, bool>.from(state.enabledStatus)..remove(event.word);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_keywords', updatedWords);
    await prefs.remove('enabled_${event.word}');
    await prefs.remove('vibration_${event.word}');

    emit(state.copyWith(triggerWords: updatedWords, enabledStatus: updatedStatus));
  }

  Future<void> _onToggle(ToggleTriggerWord event, Emitter<TriggerWordsState> emit) async {
    final updatedStatus = Map<String, bool>.from(state.enabledStatus);
    updatedStatus[event.word] = event.isEnabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enabled_${event.word}', event.isEnabled);

    emit(state.copyWith(enabledStatus: updatedStatus));
  }
}
