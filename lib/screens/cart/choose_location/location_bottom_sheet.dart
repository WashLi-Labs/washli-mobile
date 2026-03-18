import 'package:flutter/material.dart';
import '../../../widgets/input_fields/custom_search_bar.dart';
import 'widgets/location_option_row.dart';
import 'widgets/add_address_row.dart';
import 'choose_location.dart';

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const Text(
            'Choose Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 16),
          
          const CustomSearchBar(
            hintText: 'Search',
          ),
          const SizedBox(height: 20),
          
          LocationOptionRow(
            iconPath: 'assets/icons/current_location.svg',
            title: 'Your Current Location',
            onTap: () {
              Navigator.pop(context); // Close sheet
              // Handle current location selection
            },
          ),
          
          LocationOptionRow(
            iconPath: 'assets/icons/set_on_map.svg',
            title: 'Set On Map',
            onTap: () {
              Navigator.pop(context); // Close sheet
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseLocationScreen()));
            },
          ),
          
          LocationOptionRow(
            iconPath: 'assets/icons/saved_address.svg',
            title: 'Saved Address',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '0',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              ],
            ),
            onTap: () {},
          ),
          
          const SizedBox(height: 20),
          
          AddAddressRow(
            iconPath: 'assets/icons/home_outline.svg',
            title: 'Add Home',
            onTap: () {},
          ),
          
          AddAddressRow(
            iconPath: 'assets/icons/work_outline.svg',
            title: 'Add Work',
            onTap: () {},
          ),
          
          // Add extra padding at bottom if keyboard pops up or just for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
