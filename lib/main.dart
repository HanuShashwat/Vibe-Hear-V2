import 'package:flutter/material.dart';
import 'package:vibehear/pages/home.dart';
import 'package:vibehear/pages/intro_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/navigation/nav_bloc.dart';
import 'package:vibehear/blocs/profile/profile_bloc.dart';
import 'package:vibehear/blocs/profile/profile_event.dart';
import 'package:vibehear/blocs/profile/profile_state.dart';
import 'package:vibehear/blocs/trigger_words/trigger_words_bloc.dart';
import 'package:vibehear/blocs/trigger_words/trigger_words_event.dart';
import 'package:vibehear/blocs/speech/speech_bloc.dart';
import 'package:vibehear/blocs/speech/speech_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavBloc>(
          create: (context) => NavBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc()..add(LoadProfile()),
        ),
        BlocProvider<TriggerWordsBloc>(
          create: (context) => TriggerWordsBloc()..add(LoadTriggerWords()),
        ),
        BlocProvider<SpeechBloc>(
          create: (context) => SpeechBloc(
            triggerWordsBloc: context.read<TriggerWordsBloc>(),
          )..add(InitializeSpeech()),
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.isLoading) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }
          return MaterialApp(
            title: 'Hear Vibe',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6366F1), // Modern Indigo
                brightness: Brightness.light,
                primary: const Color(0xFF6366F1),
                secondary: const Color(0xFF8B5CF6), // Violet accent
                surface: Colors.white,
              ),
              textTheme: GoogleFonts.outfitTextTheme(),
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                iconTheme: IconThemeData(color: Color(0xFF334155)),
                titleTextStyle: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              cardTheme: const CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
                color: Colors.white,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                ),
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              useMaterial3: true,
            ),
            home: profileState.isFirstTime ? const IntroPage() : const Home(),
          );
        },
      ),
    );
  }
}