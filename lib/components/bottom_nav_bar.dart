import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTabChange;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GNav(
                selectedIndex: currentIndex,
                color: const Color(0xFF64748B), 
                activeColor: const Color(0xFF6366F1), 
                tabBackgroundColor: const Color(0xFFEEF2FF),
                tabBorderRadius: 16,
                gap: 8,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTabChange: onTabChange,
                tabs: const [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.vibration_rounded,
                    text: 'Vibration',
                  ),
                  GButton(
                    icon: Icons.menu_book_rounded,
                    text: 'Transcript',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
