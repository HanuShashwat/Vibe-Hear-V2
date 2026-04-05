import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class VibrationConfigPage extends StatefulWidget {
  final String triggerWord;

  const VibrationConfigPage({super.key, required this.triggerWord});

  @override
  State<VibrationConfigPage> createState() => _VibrationConfigPageState();
}

class _VibrationConfigPageState extends State<VibrationConfigPage> {
  final List<int> _pattern = [];
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPattern();
  }

  Future<void> _loadPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("vibration_${widget.triggerWord}");
    if (saved != null) {
      setState(() {
        _pattern.clear();
        _pattern.addAll(saved.map(int.parse));
      });
    }
  }

  Future<void> _savePattern() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "vibration_${widget.triggerWord}",
      _pattern.map((e) => e.toString()).toList(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Saved pattern for '${widget.triggerWord}'"),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addTime() {
    final input = int.tryParse(_timeController.text.trim());
    if (input != null && input > 0) {
      setState(() {
        _pattern.add(input);
        _timeController.clear();
      });
    }
  }

  void _resetPattern() {
    setState(() {
      _pattern.clear();
      _timeController.clear();
    });
  }

  Future<void> _testPattern() async {
    final supported = await Vibration.hasVibrator();
    if (supported == true) {
      final formattedPattern = [0];
      for (final ms in _pattern) {
        formattedPattern.add(ms);
        formattedPattern.add(150);
      }
      formattedPattern.removeLast();

      Vibration.vibrate(pattern: formattedPattern);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.triggerWord),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
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
                            _pattern.isEmpty
                                ? "No pattern set"
                                : _pattern.map((e) => "${e}ms").join(" • "),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _pattern.isEmpty ? FontWeight.normal : FontWeight.bold,
                              color: _pattern.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF6366F1),
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
                              onPressed: _addTime,
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
                      onPressed: _resetPattern,
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
                      onPressed: _testPattern,
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
                onPressed: _savePattern,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                ),
                child: const Text("SAVE PATTERN", style: TextStyle(fontSize: 18, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}