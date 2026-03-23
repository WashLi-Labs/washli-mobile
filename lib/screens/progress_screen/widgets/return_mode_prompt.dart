import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/order/place_order_response.dart';
import '../../../services/api/order_api_service.dart';
import '../../../providers/order_placement_provider.dart';

class ReturnModePrompt extends ConsumerStatefulWidget {
  final PlaceOrderResponse order;

  const ReturnModePrompt({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ReturnModePrompt> createState() => _ReturnModePromptState();
}

class _ReturnModePromptState extends ConsumerState<ReturnModePrompt> {
  bool _isLoading = false;

  Future<void> _handleSelection(String mode) async {
    setState(() => _isLoading = true);
    try {
      final service = OrderApiService();
      await service.setReturnMode(
        orderId: widget.order.orderId,
        returnMode: mode,
        deliveryAddress: mode == 'PARTNER' ? widget.order.pickupAddress : null,
        preferredProvider: mode == 'PARTNER' ? 'PICKME' : null,
      );
      
      // Force refresh the order to reflect the new returnMode
      ref.invalidate(orderApiServiceProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set return mode: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF1E5EE6)),
            SizedBox(height: 16),
            Text(
              'Processing...',
              style: TextStyle(
                color: Color(0xFF2D2D3A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'How do you want your clothes back?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _OptionCard(
                  title: 'Self-pickup',
                  subtitle: 'Collect at laundry',
                  icon: Icons.storefront_outlined,
                  onTap: () => _handleSelection('WALK_IN'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _OptionCard(
                  title: 'Delivery',
                  subtitle: 'Send to address',
                  icon: Icons.moped_outlined,
                  onTap: () => _handleSelection('PARTNER'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF1E5EE6)),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
