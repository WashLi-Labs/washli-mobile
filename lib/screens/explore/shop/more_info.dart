import 'package:flutter/material.dart';
import 'package:washli_mobile/widgets/buttons/back_button.dart';
import 'package:washli_mobile/screens/explore/shop/widgets/more_info_map.dart';

class MoreInfoScreen extends StatelessWidget {
  final Map<String, dynamic> laundry;

  const MoreInfoScreen({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Center(
          child: CustomBackButton(
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60), // Space for profile image overlap
                  _buildTitleSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Ratings"),
                  const SizedBox(height: 8),
                  _buildRatings(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Address"),
                  const SizedBox(height: 8),
                  _buildAddress(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Opening Hours"),
                  const SizedBox(height: 8),
                  _buildOpeningHours(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Delivery Information"),
                  const SizedBox(height: 16),
                  _buildDeliveryDetails(),
                  const SizedBox(height: 16),
                  const MoreInfoMap(), // Using Google Maps widget
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Contact"),
                  const SizedBox(height: 16),
                  _buildContactSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Banner Image
        Image.asset(
         'assets/images/laundry shop.png', // Fallback or specific banner
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        // Profile Image
        Positioned(
          bottom: -40,
          left: 24,
          child: Container(
            padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                laundry['image'] ?? 'assets/images/laundry shop.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              laundry['name'] ?? "Wijesinghe Laundry",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D3A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Colombo", // Placeholder or dynamic
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
             shape: BoxShape.circle,
             border: Border.all(color: Colors.grey.shade300)
          ),
          child: const Icon(Icons.phone_outlined, color: Colors.grey, size: 20),
        )
      ],
    );
  }
  
    Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D2D3A),
      ),
    );
  }

    Widget _buildRatings() {
       return Row(
         mainAxisAlignment: MainAxisAlignment.end,
         children: const [
           Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey),
           SizedBox(width: 4),
           Text("100k", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))
         ],
       );
    }

  Widget _buildAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const Expanded(
           child: Text(
            "No 24, Dehiwala Road, Maharagama",
             style: TextStyle(color: Color(0xFF535353), fontSize: 14),
           ),
         ),
         Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
           decoration: BoxDecoration(
             color: Colors.grey.shade200,
             borderRadius: BorderRadius.circular(20)
           ),
           child: Row(
             children: const [
                Icon(Icons.directions_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Direction", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))
             ],
           ),
         )
      ],
    );
  }

  Widget _buildOpeningHours() {
    return Column(
      children: [
        _buildTimeRow("Monday - Friday", "10.00 AM - 10.00 PM"),
        const SizedBox(height: 8),
        _buildTimeRow("Saturday", "10.00 AM - 10.00 PM"),
      ],
    );
  }

  Widget _buildTimeRow(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: const TextStyle(color: Color(0xFF535353), fontSize: 14)),
        Text(time, style: const TextStyle(color: Color(0xFF2D2D3A), fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }



  Widget _buildDeliveryDetails() {
    return Column(
      children: [
        _buildDetailRow(Icons.access_time, "Estimated delivery time", "Est : 50 mins"),
        const SizedBox(height: 12),
        _buildDetailRow(Icons.directions_walk, "Self Pickup", "Available"),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF535353)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF535353), fontSize: 14))),
        Text(value, style: const TextStyle(color: Color(0xFF2D2D3A), fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
  
  Widget _buildContactSection() {
     return Column(
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
              const Text("Outlet", style: TextStyle(color: Color(0xFF535353), fontSize: 14)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   border: Border.all(color: Colors.grey.shade300)
                ),
                child: const Icon(Icons.phone_outlined, color: Colors.grey, size: 16),
              )
           ],
         ),
          const SizedBox(height: 16),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: const [
              Text("Support", style: TextStyle(color: Color(0xFF535353), fontSize: 14)),
              Text("070 456 7834", style: TextStyle(color: Color(0xFF2D2D3A), fontSize: 14, fontWeight: FontWeight.w500)),
           ],
         ),
       ],
     );
  }
}
