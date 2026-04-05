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
    for (final key in ['Emergency', 'Come Here', 'Help Me']) {
      await prefs.remove('vibration_$key');
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vibration patterns cleared")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color blueTone = const Color.fromRGBO(242, 250, 255, 1);
    return Scaffold(
      backgroundColor: blueTone,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),


            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: blueTone,
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "⚠️ Danger Zone",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => _clearAllData(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Clear All App Data"),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _clearVibrationPatterns(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Reset Vibration Patterns"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}