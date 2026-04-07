import 'package:flutter/material.dart';
import 'package:vibehear/pages/setup_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E7FF), Color(0xFFF1F5F9)], // Indigo 100 to Slate 100
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // logo
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, val, child) {
                  return Transform.scale(
                    scale: val,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'lib/images/logo_vibe_hear.png',
                      height: 180,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // title
              const Text(
                'Vibe Hear',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 52,
                  color: Color(0xFF0F172A), // Slate 900
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              // subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Feel the Sound\nStay Connected",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xFF64748B), // Slate 500
                    height: 1.3,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // start now button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim, secAnim) => const SetupPage(),
                        transitionsBuilder: (context, anim, secAnim, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFF6366F1).withValues(alpha: 0.5),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
