import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vibration_config_page.dart';

class VibrationPage extends StatefulWidget {
  const VibrationPage({super.key});

  @override
  State<VibrationPage> createState() => _VibrationPageState();
}

class _VibrationPageState extends State<VibrationPage> {
  List<String> triggerWords = [];
  Map<String, bool> enabledStatus = {};
  final TextEditingController _keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKeywords();
  }

  Future<void> _loadKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeywords = prefs.getStringList('custom_keywords') ?? ['Emergency', 'Come Here', 'Help Me'];
    
    setState(() {
      triggerWords = savedKeywords;
      for (final word in triggerWords) {
        enabledStatus[word] = prefs.getBool('enabled_$word') ?? true;
      }
    });

    if (prefs.getStringList('custom_keywords') == null) {
      await prefs.setStringList('custom_keywords', savedKeywords);
    }
  }

  Future<void> _addKeyword() async {
    final word = _keywordController.text.trim();
    if (word.isEmpty) return;
    if (triggerWords.contains(word)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keyword already exists.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      triggerWords.add(word);
      enabledStatus[word] = true;
    });
    
    await prefs.setStringList('custom_keywords', triggerWords);
    await prefs.setBool('enabled_$word', true);
    _keywordController.clear();
  }

  Future<void> _deleteKeyword(String word) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      triggerWords.remove(word);
      enabledStatus.remove(word);
    });
    await prefs.setStringList('custom_keywords', triggerWords);
    await prefs.remove('enabled_$word');
    await prefs.remove('vibration_$word');
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
               _addKeyword();
               Navigator.pop(context);
             },
             style: ElevatedButton.styleFrom(
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
             ),
             child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
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
            child: triggerWords.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic_off_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text("No trigger words added yet.\nPress '+' to add.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8))),
                    ],
                  )
                )
              : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: triggerWords.length,
              itemBuilder: (context, index) {
                final word = triggerWords[index];
                final isEnabled = enabledStatus[word] ?? true;

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
                              onChanged: (value) async {
                                setState(() {
                                  enabledStatus[word] = value;
                                });
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('enabled_$word', value);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteKeyword(word),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF6366F1),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}