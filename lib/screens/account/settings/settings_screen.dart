import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../Auth/role.dart';
import '../../../services/firebase/auth_service.dart';
import 'widgets/settings_menu_item.dart';
import 'widgets/settings_profile_header.dart';
import 'widgets/settings_section.dart';
import 'add_home/add_home_screen.dart';
import '../../../widgets/buttons/back_button.dart';

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
                  CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                          onTap: () => _showComingSoon('Add Home'),
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
