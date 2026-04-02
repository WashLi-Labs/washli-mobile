import 'package:flutter/material.dart';
import '../../../widgets/buttons/skip_btn.dart';
import '../../../widgets/buttons/rate_button.dart';
import '../../home/home_screen.dart';
import '../../explore/explore_screen.dart';

import '../../../widgets/input_fields/rating_feedback.dart';

class MerchantRatingScreen extends StatefulWidget {
  final String merchantName;

  const MerchantRatingScreen({
    super.key,
    this.merchantName = 'Fresh Wash Laundry',
  });

  @override
  State<MerchantRatingScreen> createState() => _MerchantRatingScreenState();
}

class _MerchantRatingScreenState extends State<MerchantRatingScreen> {
  bool? _isThumbsUp;
  final List<String> _selectedFeedback = [];
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _laundryFeedbackTags = [
    'Clean clothes',
    'Good scent',
    'On-time delivery',
    'Professional service',
    'Careful handling',
    'Good packaging',
    'Fair pricing',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _navigateToExplore() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ExploreScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SkipBtn(onTap: _navigateToExplore),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.merchantName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'How was your order?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(height: 1),
                    const SizedBox(height: 40),

                    // Thumb Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildThumbButton(false),
                        const SizedBox(width: 40),
                        _buildThumbButton(true),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Feedback Tags
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _laundryFeedbackTags.map((tag) {
                        final isSelected = _selectedFeedback.contains(tag);
                        return ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedFeedback.add(tag);
                              } else {
                                _selectedFeedback.remove(tag);
                              }
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFFE3F2FD),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF0062FF) : Colors.black87,
                            fontSize: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF0062FF) : Colors.grey.shade300,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    // Additional Feedback TextField
                    RatingFeedbackInput(controller: _feedbackController),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Rate Button at bottom
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: RateButton(onTap: _navigateToExplore),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbButton(bool isUp) {
    final bool isSelected = _isThumbsUp == isUp;
    final Color activeColor = isUp ? Colors.green : Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isThumbsUp = isUp;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(
          isUp ? Icons.thumb_up : Icons.thumb_down,
          size: 40,
          color: isSelected ? activeColor : Colors.grey.shade400,
        ),
      ),
    );
  }
}
