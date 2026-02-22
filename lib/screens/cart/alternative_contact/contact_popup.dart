import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactPopup extends StatelessWidget {
  const ContactPopup({super.key});

  Future<void> _openPhoneBook(BuildContext context) async {
    // Request permission to read contacts
    if (await FlutterContacts.requestPermission()) {
      // Open native contact picker
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && context.mounted) {
        // Here you can handle the selected contact if needed
        Navigator.pop(context, contact);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact permission denied')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF0062FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Set Secondary Contact',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          
          // Options
          _buildOption(
            icon: Icons.contact_phone_outlined,
            title: 'Phone book',
            onTap: () => _openPhoneBook(context),
          ),
          const SizedBox(height: 12),
          
          _buildOption(
            icon: Icons.person_outline,
            title: 'Set as you',
            onTap: () => _openPhoneBook(context),
          ),
          const SizedBox(height: 12),
          
          _buildOption(
            icon: Icons.history,
            title: 'Recent contacts',
            trailingText: '0',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF3F4F6), thickness: 1, height: 1),
          const SizedBox(height: 24),
          
          // Create New Contact Action
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create New Contact',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0062FF), width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, size: 16, color: Color(0xFF0062FF)),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(child: const SizedBox(height: 8)),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEFF3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF1E1E2D)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF1E1E2D)),
          ],
        ),
      ),
    );
  }
}
