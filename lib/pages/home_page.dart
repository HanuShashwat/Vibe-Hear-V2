import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'dart:ui'; // For BackdropFilter

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
  late AnimationController _rippleController;

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

    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
        onStatus: (val) {
          if (val == 'notListening' || val == 'done') {
             if (mounted) {
               setState(() => _isListening = false);
               Future.delayed(const Duration(milliseconds: 200), () {
                 if (mounted && !_isListening) _listenContinuous();
               });
             }
          }
        },
        onError: (errorNotification) {
          if (mounted) {
             setState(() => _isListening = false);
             Future.delayed(const Duration(seconds: 1), () {
                 if (mounted && !_isListening) _listenContinuous();
             });
          }
        },
      );
      if (available) {
        _listenContinuous();
      } else {
        if (!mounted) return;
        setState(() {
          detectionMessage = "Speech mode unavailable.";
          _rippleController.stop();
        });
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required.")),
      );
    }
  }

  void _listenContinuous() async {
    if (!_speech.isAvailable || _speech.isListening) return;
    
    if (mounted) {
      setState(() {
        _isListening = true;
        detectionMessage = 'Actively listening...';
      });
      if (!_rippleController.isAnimating) _rippleController.repeat();
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
        Vibration.vibrate(pattern: [0, 500, 150, 500]);
      }
    }
    
    // reset message briefly
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isListening) {
        setState(() {
          detectionMessage = 'Actively listening...';
        });
      }
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.nickName.isNotEmpty ? widget.nickName : widget.firstName;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Hey $displayName,',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "I am listening to your keywords.\nKeep the app running around you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  )
                ],
              ),
            ),
            
            const Spacer(flex: 2),

            // Animated Ripple Orb
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                   AnimatedBuilder(
                     animation: _rippleController,
                     builder: (context, child) {
                       return Container(
                         width: 250 + (_rippleController.value * 50),
                         height: 250 + (_rippleController.value * 50),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: const Color(0xFF6366F1).withValues(
                             alpha: 1.0 - _rippleController.value,
                           ),
                         ),
                       );
                     },
                   ),
                   AnimatedBuilder(
                     animation: _rippleController,
                     builder: (context, child) {
                       return Container(
                         width: 200 + ((_rippleController.value + 0.5) % 1.0 * 50),
                         height: 200 + ((_rippleController.value + 0.5) % 1.0 * 50),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: const Color(0xFF8B5CF6).withValues(
                             alpha: 1.0 - ((_rippleController.value + 0.5) % 1.0),
                           ),
                         ),
                       );
                     },
                   ),
                   Container(
                     width: 140,
                     height: 140,
                     decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                       gradient: LinearGradient(
                         colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                       ),
                       boxShadow: [
                         BoxShadow(
                           color: Color(0x666366F1),
                           blurRadius: 20,
                           spreadRadius: 5,
                         ),
                       ],
                     ),
                     child: const Center(
                       child: Icon(Icons.mic, color: Colors.white, size: 50),
                     ),
                   ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Glassmorphic status card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Sound waves icon
                         Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.graphic_eq, color: Color(0xFF6366F1)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               const Text(
                                 "Status",
                                 style: TextStyle(
                                   color: Color(0xFF94A3B8),
                                   fontWeight: FontWeight.w600,
                                   fontSize: 14,
                                 ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                  detectionMessage,
                                  style: TextStyle(
                                    color: detectionMessage.startsWith('Detected') 
                                      ? Colors.redAccent 
                                      : const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                               ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}