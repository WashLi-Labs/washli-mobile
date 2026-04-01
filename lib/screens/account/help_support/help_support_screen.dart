import 'package:flutter/material.dart';
import '../../../../widgets/buttons/back_button.dart';
import 'topics/order_delivery_issues_screen.dart';
import 'topics/laundry_quality_concerns_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                    'Help & Support',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                        'Topics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTopicItem(
                        'Order & Delivery Issues',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderDeliveryIssuesScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                      _buildTopicItem(
                        'Laundry & Quality Concerns',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaundryQualityConcernsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                      _buildTopicItem('Payments & WashLi Credits'),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                      _buildTopicItem('Account & Profile'),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                      _buildTopicItem('App Technical Support'),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
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

  Widget _buildTopicItem(String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      leading: const Icon(
        Icons.support_outlined,
        color: Colors.black87,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
