import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../widgets/buttons/back_button.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  Future<void> _launchWashliWebsite(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch website')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch website')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: CustomBackButton(
                onTap: () => Navigator.pop(context),
              ),
            ),
            
            // Large Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Legal',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Premium WashLi dark tone
                  letterSpacing: -0.5,
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Items
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _buildLegalItem(context, 'Refund Policy', 'https://washli.lk/refund'),
                  _buildLegalItem(context, 'Privacy Policy', 'https://washli.lk/privacy'),
                  _buildLegalItem(context, 'Terms & Conditions', 'https://washli.lk/terms'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem(BuildContext context, String title, String url) {
    return InkWell(
      onTap: () => _launchWashliWebsite(context, url),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151), // Dark gray text mirroring settings content
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
