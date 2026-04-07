import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/navigation/nav_bloc.dart';
import 'package:vibehear/blocs/navigation/nav_event.dart';
import 'package:vibehear/blocs/navigation/nav_state.dart';
import 'package:vibehear/components/bottom_nav_bar.dart';
import 'package:vibehear/pages/about_page.dart';
import 'package:vibehear/pages/home_page.dart';
import 'package:vibehear/pages/settings_page.dart';
import 'package:vibehear/pages/setup_page.dart';
import 'package:vibehear/pages/support.dart';
import 'package:vibehear/pages/transcript_page.dart';
import 'package:vibehear/pages/vibration_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  List<Widget> _getPages() {
    return [
      const HomePage(),
      const VibrationPage(),
      const TranscriptPage(),
    ];
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String title,
    required Widget page,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF64748B)),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages();

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: BottomNavBar(
            currentIndex: state.tabIndex,
            onTabChange: (index) {
              context.read<NavBloc>().add(NavigateToTab(index));
            },
          ),
          body: pages[state.tabIndex],
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.sort, size: 28),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            title: const Text('Hear Vibe'),
          ),
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF2FF),
                    border: Border(bottom: BorderSide.none),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/images/logo_vibe_hear.png', height: 80),
                        const SizedBox(height: 12),
                        const Text("Vibe Hear",
                            style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Profile Settings',
                    page: const SetupPage(),
                    context: context),
                _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    page: const SettingsPage(),
                    context: context),
                _buildDrawerItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Support',
                    page: const Support(),
                    context: context),
                _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    page: const AboutPage(),
                    context: context),
              ],
            ),
          ),
        );
      },
    );
  }
}