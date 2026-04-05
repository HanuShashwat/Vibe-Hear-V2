import 'package:flutter/material.dart';
import 'package:vibehear/pages/home.dart';
import 'package:vibehear/pages/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  final firstName = prefs.getString('firstName') ?? '';
  final middleName = prefs.getString('middleName') ?? '';
  final lastName = prefs.getString('lastName') ?? '';
  final nickName = prefs.getString('nickName') ?? '';

  runApp(MyApp(
    isFirstTime: isFirstTime,
    firstName: firstName,
    middleName: middleName,
    lastName: lastName,
    nickName: nickName,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String firstName;
  final String middleName;
  final String lastName;
  final String nickName;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.nickName,
  });

  @override
  Widget build(BuildContext context) {
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
      home: isFirstTime
          ? const IntroPage()
          : Home(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        nickName: nickName,
      ),
    );
  }
}