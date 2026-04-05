import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _clearAllData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("This will erase all saved preferences and restart the app."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Confirm", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (Platform.isAndroid || Platform.isIOS) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }

  Future<void> _clearVibrationPatterns(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeywords = prefs.getStringList('custom_keywords') ?? [];
    for (final key in savedKeywords) {
      await prefs.remove('vibration_$key');
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vibration patterns cleared")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                          SizedBox(width: 8),
                          Text(
                            "Danger Zone",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _clearAllData(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text("Clear All App Data"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _clearVibrationPatterns(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent, width: 2),
                          elevation: 0,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text("Reset Vibration Patterns"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}