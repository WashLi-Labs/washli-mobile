import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/merchant_profile_model.dart';
import '../../../providers/merchants_list_provider.dart';
import '../../../services/firebase/merchant_firebase_service.dart';
import '../../explore/explore_screen.dart';
import '../../explore/shop/shop_details_screen.dart';

class NearbyLaundryCard extends ConsumerWidget {
  const NearbyLaundryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(nearbyMerchantsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Laundries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExploreScreen()),
                ),
                child: const Text('See all'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          merchantsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    const Text('Could not load laundries.',
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => ref.invalidate(nearbyMerchantsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text('No laundries available yet.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              // Show up to 4 nearest on home screen
              final preview = items.take(4).toList();
              return Column(
                children: preview
                    .map((item) => _LaundryRow(item: item))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Converts a [MerchantWithDistance] to the format expected by ShopDetailsScreen.
  Map<String, dynamic> _toShopCardMap(MerchantWithDistance item) {
    final m = item.merchant;
    return {
      'name': m.outletName.isNotEmpty ? m.outletName : 'Laundry',
      'image': m.outletLogo?.isNotEmpty == true
          ? m.outletLogo
          : 'assets/images/laundry shop.png',
      'isNetworkImage': m.outletLogo?.isNotEmpty == true,
      'fee': 'Contact for pricing',
      'time': item.distanceLabel.isNotEmpty ? item.distanceLabel : 'Varies',
      'likes': m.city.isNotEmpty ? m.city : '—',
      'status': m.isActive ? null : 'Closed',
      'statusColor': Colors.red,
      'address': m.outletAddress,
      'menuDocument': m.menuDocument ?? '',
      'logo': m.outletLogo,
      'lat': m.location?.lat,
      'lng': m.location?.lng,
      'phone': m.managerPhone,
      'operatingHours': m.operatingHours.map((h) => {
            'day': h.day,
            'isOpen': h.isOpen,
            'openTime': h.openTime,
            'closeTime': h.closeTime,
          }).toList(),
      'services': const <Map<String, dynamic>>[],
    };
  }
}

// ─────────────────────────────────────────────────────────────
// Individual row card
// ─────────────────────────────────────────────────────────────

class _LaundryRow extends StatelessWidget {
  final MerchantWithDistance item;
  const _LaundryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final MerchantProfileModel m = item.merchant;
    final bool hasNetworkImage =
        m.outletLogo != null && m.outletLogo!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD).withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopDetailsScreen(
                  laundry: NearbyLaundryCard()._toShopCardMap(item),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ── Text info ──
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        m.outletName.isNotEmpty ? m.outletName : 'Laundry',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        m.outletAddress.isNotEmpty ? m.outletAddress : m.city,
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          // Distance badge
                          if (item.distanceLabel.isNotEmpty) ...[
                            const Icon(Icons.near_me,
                                size: 10, color: Color(0xFF2688EA)),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                item.distanceLabel,
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFF2688EA)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Open/closed badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: m.isActive
                                  ? Colors.green.withOpacity(0.12)
                                  : Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              m.isActive ? 'Open' : 'Closed',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: m.isActive ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Thumbnail ──
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasNetworkImage
                        ? Image.network(
                            m.outletLogo!,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/shop1.jpg',
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/shop1.jpg',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
