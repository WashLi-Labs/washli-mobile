import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_spacing.dart';

class LocationEnablePopup extends StatelessWidget {
  const LocationEnablePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      backgroundColor: const Color(0xFFEDECFF), // Light purple background as in image
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location update failed',
              style: AppTextStyles.heading.copyWith(
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'To continue washli, let your device turn on location using Google\'s Location Service.',
              style: AppTextStyles.body.copyWith(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.button.copyWith(
                      color: const Color(0xFF4B49AC), // Purple color from image
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Setting',
                    style: AppTextStyles.button.copyWith(
                      color: const Color(0xFF4B49AC),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to show the popup
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LocationEnablePopup(),
    );
  }
}
