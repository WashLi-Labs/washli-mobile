import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../Auth/login.dart';
import '../../../services/auth_service.dart';
import 'widgets/settings_menu_item.dart';
import 'widgets/settings_profile_header.dart';
import 'widgets/settings_section.dart';
import 'add_home/add_home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _firstName = 'User';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'User';
      _lastName = prefs.getString('lastName') ?? '';
      _email = prefs.getString('email') ?? '';
      _phone = prefs.getString('phone') ?? '';
      final path = prefs.getString('profileImagePath');
      if (path != null && path.isNotEmpty) {
        _profileImage = File(path);
      }
    });
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF007DFC)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Clear preferences and sign out from Firebase
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await AuthService().signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF007DFC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  ImageProvider get _imageProvider => _profileImage != null
      ? FileImage(_profileImage!) as ImageProvider
      : const AssetImage('assets/images/profile1.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // ───── Top App Bar ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0F000000), // black 6%
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ───── Scrollable Content ─────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    SettingsProfileHeader(
                      name: '$_firstName $_lastName'.trim(),
                      email: _email,
                      phone: _phone.isNotEmpty ? _phone : null,
                      imageProvider: _imageProvider,
                    ),
                    const SizedBox(height: 28),

                    // ── App Settings Section ──
                    SettingsSection(
                      title: 'APP SETTINGS',
                      items: [
                        SettingsMenuItem(
                          icon: Icons.home_rounded,
                          title: 'Add Home',
                          subtitle: 'Set your home address',
                          onTap: () async {
                            final result = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddHomeScreen(),
                              ),
                            );
                            if (result != null && result.isNotEmpty && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Home address saved: $result'),
                                  backgroundColor: const Color(0xFF007DFC),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        SettingsMenuItem(
                          icon: Icons.work_rounded,
                          title: 'Add Work',
                          subtitle: 'Set your work address',
                          onTap: () => _showComingSoon('Add Work'),
                        ),
                      ],
                    ),

                    // ── Legal Section ──
                    SettingsSection(
                      title: 'LEGAL',
                      items: [
                        SettingsMenuItem(
                          icon: Icons.gavel_rounded,
                          title: 'Legal',
                          subtitle: 'Terms, Privacy & Policies',
                          onTap: () => _showComingSoon('Legal'),
                        ),
                      ],
                    ),

                    // ── Account Section ──
                    SettingsSection(
                      title: 'ACCOUNT',
                      items: [
                        SettingsMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Sign Out',
                          isDestructive: true,
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
