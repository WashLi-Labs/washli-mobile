import 'package:flutter/material.dart';
import '../../../../../widgets/buttons/back_button.dart';

class AppTechnicalSupportScreen extends StatelessWidget {
  const AppTechnicalSupportScreen({super.key});

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
                  const Expanded(
                    child: Text(
                      'App Technical Support',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fix technical issues related to the WashLi app.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildFaqItem(
                        '1. App crashing',
                        [
                          'Update app to latest version',
                          'Restart device',
                          'Clear app cache',
                        ],
                      ),
                      _buildFaqItem(
                        '2. App loading slowly',
                        [
                          'Check internet connection',
                          'Close background apps',
                        ],
                      ),
                      _buildFaqItem(
                        '3. Features not working',
                        [
                          'Update app',
                          'Reinstall if issue continues',
                        ],
                      ),
                      _buildFaqItem(
                        '4. Unable to place order',
                        [
                          'Check all required fields are filled',
                          'Ensure service availability in your area',
                        ],
                      ),
                      _buildFaqItem(
                        '5. Notifications not received',
                        [
                          'Enable notifications in settings',
                          'Check app permissions',
                        ],
                      ),
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

  Widget _buildFaqItem(String question, List<String> answers) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Very light grey bg
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconColor: const Color(0xFF0057E6), // Match brand blue roughly
        collapsedIconColor: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
        children: answers.map((answer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0057E6), // Theme blue bullet
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
