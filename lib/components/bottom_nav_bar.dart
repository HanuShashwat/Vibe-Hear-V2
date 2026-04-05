import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return GNav(
        color: Colors.grey[500],
        activeColor: Color.fromRGBO(8, 129, 208, 1),
        tabActiveBorder: Border.all(
            color: Colors.blue.shade100,
            width: 0.5,
        ),
        tabBackgroundColor: Colors.blue.shade50,
        tabBorderRadius: 12,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        tabMargin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        onTabChange: (value) => onTabChange!(value),
          tabs: [
            GButton(
                icon: Icons.home,
              text: ' Home',
            ),
            GButton(
              icon: Icons.vibration,
              text: ' Vibration',
            ),
            GButton(
              icon: Icons.menu_book,
              text: ' Transcript',
            ),
          ],
      );
  }
}
