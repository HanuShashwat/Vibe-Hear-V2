import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/vibration_pattern/vibration_pattern_bloc.dart';
import 'package:vibehear/blocs/vibration_pattern/vibration_pattern_event.dart';
import 'package:vibehear/blocs/vibration_pattern/vibration_pattern_state.dart';

class VibrationConfigPage extends StatefulWidget {
  final String triggerWord;

  const VibrationConfigPage({super.key, required this.triggerWord});

  @override
  State<VibrationConfigPage> createState() => _VibrationConfigPageState();
}

class _VibrationConfigPageState extends State<VibrationConfigPage> {
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VibrationPatternBloc()..add(LoadPattern(widget.triggerWord)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.triggerWord),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlocConsumer<VibrationPatternBloc, VibrationPatternState>(
              listener: (context, state) {
                // We could listen for saved events if needed
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vibration Pattern",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B)
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Build a custom vibration sequence by adding buzz durations (in milliseconds).",
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 60),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Center(
                                child: Text(
                                  state.pattern.isEmpty
                                      ? "No pattern set"
                                      : state.pattern.map((e) => "${e}ms").join(" • "),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: state.pattern.isEmpty ? FontWeight.normal : FontWeight.bold,
                                    color: state.pattern.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _timeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "Duration (e.g. 500)",
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final input = int.tryParse(_timeController.text.trim());
                                      if (input != null && input > 0) {
                                        context.read<VibrationPatternBloc>().add(AddDuration(input));
                                        _timeController.clear();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.read<VibrationPatternBloc>().add(ResetPattern());
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF64748B)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              foregroundColor: const Color(0xFF64748B),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Reset", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<VibrationPatternBloc>().add(TestPattern());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.vibration),
                            label: const Text("Test", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<VibrationPatternBloc>().add(SavePattern());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Saved pattern for '${widget.triggerWord}'"),
                            backgroundColor: const Color(0xFF6366F1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                      ),
                      child: const Text("SAVE PATTERN", style: TextStyle(fontSize: 18, letterSpacing: 1)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}