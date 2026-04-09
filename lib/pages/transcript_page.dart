import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/speech/speech_bloc.dart';
import 'package:vibehear/blocs/speech/speech_event.dart';
import 'package:vibehear/blocs/speech/speech_state.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Live Transcript',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      BlocBuilder<SpeechBloc, SpeechState>(
                        builder: (context, state) {
                          final isPaused = state.isPaused;
                          return GestureDetector(
                            onTap: () {
                              context.read<SpeechBloc>().add(ToggleListening());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isPaused
                                    ? Colors.orange.withValues(alpha: 0.1)
                                    : const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPaused ? Icons.mic_off_rounded : Icons.mic_rounded,
                                color: isPaused ? Colors.orange : const Color(0xFF8B5CF6),
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Spoken text translated into written English in real-time.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Transcript Display
            Expanded(
              child: BlocConsumer<SpeechBloc, SpeechState>(
                listener: (context, state) {
                   Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                },
                builder: (context, speechState) {
                  final history = speechState.transcriptHistory;
                  final current = speechState.currentTranscript;

                  if (history.isEmpty && current.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.speaker_notes_off_rounded,
                              size: 64, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            "Waiting for speech...",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    itemCount: history.length + (current.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      final isCurrent = current.isNotEmpty && index == history.length;
                      final text = isCurrent ? current : history[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? const Color(0xFFEEF2FF).withValues(alpha: 0.8)
                                    : Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCurrent
                                      ? const Color(0xFF8B5CF6).withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.8),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: const Color(0xFF334155),
                                  fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
                                  fontStyle: isCurrent ? FontStyle.italic : FontStyle.normal,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
