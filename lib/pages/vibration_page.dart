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

  final Color blueTone = const Color.fromRGBO(242, 250, 255, 1);

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

    // Save default list back if it hasn't been saved yet
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
        title: const Text("Add Custom Keyword"),
        content: TextField(
          controller: _keywordController,
          decoration: const InputDecoration(hintText: "Enter keyword or phrase"),
          textCapitalization: TextCapitalization.words,
        ),
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
      backgroundColor: blueTone,
      appBar: AppBar(
        title: const Text("Trigger Words", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: blueTone,
        foregroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              "Add custom phrases. When the app is listening and hears one of these, it will vibrate using the specific pattern you set.",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          Expanded(
            child: triggerWords.isEmpty 
              ? const Center(child: Text("No trigger words added yet.\nPress '+' to add.", textAlign: TextAlign.center))
              : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: triggerWords.length,
              itemBuilder: (context, index) {
                final word = triggerWords[index];
                final isEnabled = enabledStatus[word] ?? true;

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(word, style: const TextStyle(fontSize: 18)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: isEnabled,
                          activeThumbColor: Colors.blue,
                          onChanged: (value) async {
                            setState(() {
                              enabledStatus[word] = value;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('enabled_$word', value);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteKeyword(word),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VibrationConfigPage(triggerWord: word),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}