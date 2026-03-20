import 'package:flutter/material.dart';
import '../../../widgets/buttons/back_button.dart';
import 'widgets/laundry_location.dart';

class MoreInfoScreen extends StatelessWidget {
  final Map<String, dynamic> laundry;

  const MoreInfoScreen({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: CustomBackButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Header Image with Overlapping Profile Picture
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image
                  laundry['isNetworkImage'] == true
                      ? Image.network(
                          laundry['image'] as String,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/laundry shop.png',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          laundry['image'] ?? 'assets/images/laundry shop.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                  // Profile Picture
                  Positioned(
                    bottom: -30,
                    left: 24,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: laundry['logo'] != null && (laundry['logo'] as String).isNotEmpty
                            ? Image.network(
                                laundry['logo'] as String,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/profile1.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/profile1.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40), // Space for overlapping profile pic

              // Title and Phone Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            laundry['name'] ?? 'Laundry',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            laundry['city'] ?? 'Colombo',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildCircleIcon(Icons.phone_outlined),
                  ],
                ),
              ),

              _buildDivider(),

              // Ratings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ratings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        const Text(
                          '100k',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _buildDivider(),

              // Address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            laundry['address'] ?? 'No Address Provided',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.directions_outlined, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Direction',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _buildDivider(),

              // Opening Hours
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opening Hours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (laundry['operatingHours'] != null && (laundry['operatingHours'] as List).isNotEmpty)
                      ...(laundry['operatingHours'] as List).map((h) {
                        final hours = h as Map<String, dynamic>;
                        final day = hours['day'] ?? '—';
                        final isOpen = hours['isOpen'] == true;
                        final openTime = hours['openTime'] ?? '';
                        final closeTime = hours['closeTime'] ?? '';
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildInfoRow(
                            day, 
                            isOpen ? '$openTime - $closeTime' : 'Closed'
                          ),
                        );
                      })
                    else
                      const Text(
                        'Not specified',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),

              _buildDivider(),

              // Delivery Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LaundryLocationMap(
                      lat: laundry['lat'] as double?,
                      lng: laundry['lng'] as double?,
                    ),
                    const SizedBox(height: 16),
                    _buildIconInfoRow(Icons.access_time_outlined, 'Estimated delivery time', 'Est : 50 mins'),
                    const SizedBox(height: 8),
                    _buildIconInfoRow(Icons.directions_walk, 'Self Pickup', 'Available'),
                  ],
                ),
              ),

              _buildDivider(),

              // Contact
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Outlet
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Outlet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        Text(
                          laundry['phone'] ?? '—',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Support
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Support',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        Text(
                          '070 456 7834',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Divider(
        thickness: 1,
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2D3A),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2D3A),
          ),
        ),
      ],
    );
  }

  Widget _buildIconInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D2D3A),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2D3A),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(
        icon,
        size: 18,
        color: Colors.grey[600],
      ),
    );
  }
}
