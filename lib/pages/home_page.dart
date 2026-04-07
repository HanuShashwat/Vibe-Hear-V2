import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/profile/profile_bloc.dart';
import 'package:vibehear/blocs/profile/profile_state.dart';
import 'package:vibehear/blocs/speech/speech_bloc.dart';
import 'package:vibehear/blocs/speech/speech_state.dart';
import 'dart:ui'; // For BackdropFilter

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        final displayName = profileState.nickName.isNotEmpty 
            ? profileState.nickName 
            : profileState.firstName;
            
        return BlocConsumer<SpeechBloc, SpeechState>(
          listener: (context, speechState) {
            if (speechState.isListening && !_rippleController.isAnimating) {
               _rippleController.repeat();
            } else if (!speechState.isListening && _rippleController.isAnimating) {
               _rippleController.stop();
            }
          },
          builder: (context, speechState) {
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
                                          speechState.detectionMessage,
                                          style: TextStyle(
                                            color: speechState.detectionMessage.startsWith('Detected') 
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
        );
      }
    );
  }
}