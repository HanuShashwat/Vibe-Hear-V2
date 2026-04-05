import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  final String firstName;
  final String middleName;
  final String lastName;
  final String nickName;

  const HomePage({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.nickName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String detectionMessage = 'Initializing...';
  
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  List<String> _triggerWords = [];
  final Map<String, bool> _enabledStatus = {};
  DateTime _lastDetectionTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadKeywordsAndStart();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(_controller);
  }

  Future<void> _loadKeywordsAndStart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeywords = prefs.getStringList('custom_keywords') ?? ['Emergency', 'Come Here', 'Help Me'];
    
    _triggerWords = savedKeywords;
    for (final word in savedKeywords) {
      _enabledStatus[word] = prefs.getBool('enabled_$word') ?? true;
    }
    
    await _checkMicPermissionAndStart();
  }

  Future<void> _checkMicPermissionAndStart() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' && !_isListening) {
             _listenContinuous();
          }
        },
        onError: (errorNotification) {
          if (!_isListening) _listenContinuous();
        },
      );
      if (available) {
        _listenContinuous();
      } else {
        if (!mounted) return;
        setState(() {
          detectionMessage = "Speech recognition unavailable.";
        });
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission is required")),
      );
    }
  }

  void _listenContinuous() async {
    if (!_speech.isAvailable) return;
    
    if (mounted) {
      setState(() {
        _isListening = true;
        detectionMessage = 'Listening...';
      });
    }
    
    await _speech.listen(
      onResult: (result) {
         final recognizedWords = result.recognizedWords.toLowerCase();
         for (final trigger in _triggerWords) {
            if (_enabledStatus[trigger] == true && recognizedWords.contains(trigger.toLowerCase())) {
               if (DateTime.now().difference(_lastDetectionTime).inSeconds > 2) {
                 _handleDetection(trigger);
                 _lastDetectionTime = DateTime.now();
               }
            }
         }
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 5),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  Future<void> _handleDetection(String triggerWord) async {
    if (!mounted) return;
    setState(() {
      detectionMessage = 'Detected: $triggerWord';
    });

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList("vibration_$triggerWord") ?? [];
    final pattern = raw.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();

    if (await Vibration.hasVibrator() == true) {
      if (pattern.isNotEmpty) {
        final withPauses = [0];
        for (final ms in pattern) {
          withPauses.add(ms);
          withPauses.add(150);
        }
        withPauses.removeLast();
        Vibration.vibrate(pattern: withPauses);
      } else {
        // default fallback vibration pattern
        Vibration.vibrate(pattern: [0, 500, 150, 500]);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 250, 255, 1),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hi, ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      TextSpan(
                        text: widget.nickName.isNotEmpty ? widget.nickName : widget.firstName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Color.fromRGBO(8, 129, 208, 1),
                        ),
                      ),
                      TextSpan(
                        text: '!\nListening for your keywords.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.grey.shade800,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'lib/images/icon.png',
                  fit: BoxFit.contain,
                  height: 120,
                  width: 300,
                  color: const Color.fromRGBO(8, 129, 208, 1),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 260,
                  width: 275,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    detectionMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}