import 'package:flutter/material.dart';
import '../../../widgets/buttons/back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomBackButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WashLi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBodyText(
                        "At Laundry App, we are committed to protecting the privacy and security of our customers' personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our mobile app for laundry services, including pickups, deliveries, and AI features like fabric advice. By using the app, you consent to these practices.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Information We Collect'),
                      _buildBodyText(
                        "We gather personal details you provide, such as name, email, phone number, address, payment info, and laundry preferences during registration, order placement, or image uploads for AI analysis. Usage data includes location for nearest providers, device info, transaction history, and behavior patterns for predictions and reminders.\n\nAutomatically collected info covers IP address, device type, app interactions, and precise location during pickups/deliveries, similar to on-demand services.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Use of Information'),
                      _buildBodyText(
                        "Your data helps process orders, match with laundry providers, optimize routes, predict delivery times, send reminders, and personalize features like loyalty rewards or split laundry costs. We also use it for fraud prevention, service improvements, and communications about promotions.\n\nAI models analyze past data and images for fabric guidance without storing sensitive visuals long-term.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Information Sharing'),
                      _buildBodyText(
                        "We share minimal data with laundry providers and riders (e.g., pickup address, order details) to fulfill services, and with payment processors securely. No selling of data; sharing occurs only with consent, service partners bound by confidentiality, or legal requirements.\n\nData may be stored in Sri Lanka or secure locations with protective measures.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Data Security'),
                      _buildBodyText(
                        "Industry-standard encryption and measures protect against unauthorized access, though no system is fully risk-free. Location and contacts access requires your permission via device settings.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Your Choices'),
                      _buildBodyText(
                        "Update or delete account info via app settings; opt out of promotions. Disabling location/cookies limits features.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Changes to Policy'),
                      _buildBodyText(
                        "Updates posted in-app with notice; continued use implies consent.",
                      ),
                      const SizedBox(height: 30),
                      _buildSectionHeading('Contact Us'),
                      _buildBodyText(
                        "Contact support@laundryapp.lk for questions.\n(Note: General guideline; consult legal for Sri Lanka compliance.)",
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Colors.black54,
      ),
    );
  }
}
