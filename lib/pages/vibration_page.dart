import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/trigger_words/trigger_words_bloc.dart';
import 'package:vibehear/blocs/trigger_words/trigger_words_event.dart';
import 'package:vibehear/blocs/trigger_words/trigger_words_state.dart';
import 'vibration_config_page.dart';

class VibrationPage extends StatelessWidget {
  const VibrationPage({super.key});

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddKeywordDialog(
        onAdd: (word) {
          context.read<TriggerWordsBloc>().add(AddTriggerWord(word));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trigger Words"),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              "Add custom phrases. When the app is listening and hears one of these, it will vibrate using the specific pattern you set.",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 16, height: 1.4),
            ),
          ),
          Expanded(
            child: BlocBuilder<TriggerWordsBloc, TriggerWordsState>(
              builder: (context, state) {
                if (state.triggerWords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mic_off_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          "No trigger words added yet.\nPress '+' to add.", 
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8))
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: state.triggerWords.length,
                  itemBuilder: (context, index) {
                    final word = state.triggerWords[index];
                    final isEnabled = state.enabledStatus[word] ?? true;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VibrationConfigPage(triggerWord: word),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.spellcheck, color: Color(0xFF6366F1)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    word, 
                                    style: const TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B)
                                    )
                                  ),
                                ),
                                Switch.adaptive(
                                  value: isEnabled,
                                  activeTrackColor: const Color(0xFF6366F1).withValues(alpha: 0.5),
                                  activeThumbColor: const Color(0xFF6366F1),
                                  onChanged: (value) {
                                    context.read<TriggerWordsBloc>().add(ToggleTriggerWord(word, value));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () {
                                    context.read<TriggerWordsBloc>().add(DeleteTriggerWord(word));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _AddKeywordDialog extends StatefulWidget {
  final Function(String) onAdd;
  const _AddKeywordDialog({required this.onAdd});

  @override
  State<_AddKeywordDialog> createState() => _AddKeywordDialogState();
}

class _AddKeywordDialogState extends State<_AddKeywordDialog> {
  final TextEditingController _keywordController = TextEditingController();

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Custom Keyword"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: TextField(
        controller: _keywordController,
        decoration: const InputDecoration(hintText: "Enter phrase..."),
        textCapitalization: TextCapitalization.words,
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final text = _keywordController.text.trim();
            if (text.isNotEmpty) {
              widget.onAdd(text);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
          ),
          child: const Text("Add"),
        ),
      ],
    );
  }
}