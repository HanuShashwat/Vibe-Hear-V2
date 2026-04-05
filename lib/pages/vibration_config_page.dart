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

  final Color blueTone = const Color.fromRGBO(242, 250, 255, 1);

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
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved for '${widget.triggerWord}'")),
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
    if (supported) {
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
      backgroundColor: blueTone,
      appBar: AppBar(
        title: Text(widget.triggerWord),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Vibration Pattern:", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _pattern.isEmpty
                    ? "No pattern set"
                    : _pattern.map((e) => "${e}ms").join(", "),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter time in ms",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("+"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetPattern,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _testPattern,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Test"),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _savePattern,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("SAVE", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}