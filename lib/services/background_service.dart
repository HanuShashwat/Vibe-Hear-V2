import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';

const notificationChannelId = 'vibehear_service';
const notificationId = 888;
const actionMute = 'mute_action';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.actionId == actionMute) {
    SharedPreferences.getInstance().then((prefs) {
      final isMuted = prefs.getBool('is_muted') ?? false;
      prefs.setBool('is_muted', !isMuted);
    });
  }
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Hear Vibe Foreground Service',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Hear Vibe',
      initialNotificationContent: 'Initializing...',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final stt.SpeechToText speech = stt.SpeechToText();
  DateTime lastDetectionTime = DateTime.now();
  DateTime lastFinalizeTime = DateTime.now();
  DateTime lastListenAttempt = DateTime.now();
  String currentTranscript = '';
  List<String> transcriptHistory = [];

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final savedMutedState = prefs.getBool('is_muted') ?? false;
    
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          id: notificationId,
          title: 'Hear Vibe',
          body: savedMutedState ? 'Microphone Muted 🔇' : 'Actively listening for triggers...',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'Hear Vibe Foreground Service',
              icon: '@mipmap/ic_launcher',
              ongoing: true,
              actions: [
                AndroidNotificationAction(
                  actionMute,
                  'Toggle Mute',
                  cancelNotification: false,
                  showsUserInterface: false,
                ),
              ],
            ),
          ),
        );
      }
    }

    if (savedMutedState) {
      if (speech.isListening) await speech.stop();
      service.invoke('update', {'isListening': false, 'message': 'Paused (Muted)', 'currentTranscript': currentTranscript, 'history': transcriptHistory});
      return;
    }

    if (!speech.isAvailable) {
      final available = await speech.initialize(
        onStatus: (val) {
          if (val == 'notListening' || val == 'done') {
            if (currentTranscript.isNotEmpty) {
              final newHistory = List<String>.from(transcriptHistory);
              final now = DateTime.now();
              if (newHistory.isEmpty || now.difference(lastFinalizeTime).inSeconds > 3) {
                 newHistory.add(currentTranscript);
              } else {
                 newHistory[newHistory.length - 1] = '${newHistory.last} $currentTranscript';
              }
              lastFinalizeTime = now;
              transcriptHistory = newHistory;
              currentTranscript = '';
            }
          }
        },
        onError: (err) { }
      );
      if (!available) {
        service.invoke('update', {'isListening': false, 'message': 'Mic not available', 'currentTranscript': '', 'history': transcriptHistory});
        return;
      }
    }

    if (!speech.isListening) {
      final now = DateTime.now();
      if (now.difference(lastListenAttempt).inSeconds > 2) {
        lastListenAttempt = now;
        service.invoke('update', {'isListening': true, 'message': 'Actively listening...', 'currentTranscript': currentTranscript, 'history': transcriptHistory});
        try {
          await speech.listen(
            onResult: (result) async {
              currentTranscript = result.recognizedWords;
              service.invoke('update', {'isListening': true, 'message': 'Actively listening...', 'currentTranscript': currentTranscript, 'history': transcriptHistory});
              
              final recognizedWords = result.recognizedWords.toLowerCase();
              final savedKeywords = prefs.getStringList('custom_keywords') ?? ['Emergency', 'Come Here', 'Help Me'];
              
              for (final trigger in savedKeywords) {
                final isEnabled = prefs.getBool('enabled_$trigger') ?? true;
                if (isEnabled && recognizedWords.contains(trigger.toLowerCase())) {
                  if (DateTime.now().difference(lastDetectionTime).inSeconds > 2) {
                    lastDetectionTime = DateTime.now();
                    
                    final raw = prefs.getStringList("vibration_$trigger") ?? [];
                    final pattern = raw.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
                    if (await Vibration.hasVibrator() == true) {
                      if (pattern.isNotEmpty) {
                        final withPauses = <int>[0];
                        for (final ms in pattern) { withPauses.add(ms); withPauses.add(150); }
                        withPauses.removeLast();
                        Vibration.vibrate(pattern: withPauses);
                      } else {
                        Vibration.vibrate(pattern: [0, 500, 150, 500]);
                      }
                    }
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
        } catch (e) {
          debugPrint('Speech listen error: $e');
        }
      }
    }
  });

  service.on('toggleMute').listen((event) async {
      final prefs = await SharedPreferences.getInstance();
      final savedMutedState = prefs.getBool('is_muted') ?? false;
      prefs.setBool('is_muted', !savedMutedState);
  });
}
