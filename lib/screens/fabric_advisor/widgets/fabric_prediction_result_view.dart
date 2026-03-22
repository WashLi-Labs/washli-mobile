import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/fabric_advisor/fabric_prediction_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class FabricPredictionResultView extends StatelessWidget {
  final FabricPrediction prediction;

  const FabricPredictionResultView({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultRow('Fabric Type', prediction.fabric ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Confidence', prediction.confidence != null ? '${(prediction.confidence! * 100).toStringAsFixed(1)}%' : 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Wash Type', prediction.washType ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Wash Cycle', prediction.washCycle ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Water Temp.', prediction.waterTemperature ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Detergent', prediction.detergent ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Drying', prediction.drying ?? 'N/A'),
          const SizedBox(height: 12),
          _buildResultRow('Ironing', prediction.ironing ?? 'N/A'),
          
          if (prediction.careTips != null && prediction.careTips!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildResultListRow('Care Tips', prediction.careTips!),
          ],

          if (prediction.warnings != null && prediction.warnings!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildResultListRow('Warnings', prediction.warnings!),
          ],
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final textToCopy = '''
fabric name: ${prediction.fabric ?? 'N/A'}
fabric type: ${prediction.fabric ?? 'N/A'}
fabric cycle: ${prediction.washCycle ?? 'N/A'}
water temperature: ${prediction.waterTemperature ?? 'N/A'}
'''.trim();
                Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AI suggestions copied to clipboard')),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Copy AI Suggestions',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // fixed width for label alignment
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultListRow(String label, List<String> values) {
    if (values.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          ...values.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    v,
                    style: AppTextStyles.body,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
