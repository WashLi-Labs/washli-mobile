import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTopBar extends StatelessWidget {
  final String location;
  final VoidCallback onLocationTap;
  final Color contentColor; 

  const HomeTopBar({
    super.key,
    required this.location,
    required this.onLocationTap,
    this.contentColor = Colors.white, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location Dropdown
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onLocationTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: contentColor, // Use content color for the icon background
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: contentColor == Colors.white ? Colors.black : Colors.white, // Invert for contrast
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: contentColor, 
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: contentColor, size: 20),
                ],
              ),
            ),
          ),
        ),
        
        // Notification and Menu Icons
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  // TODO: Handle notification tap
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    'assets/home-icons/Bell.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8), 
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  // TODO: Handle menu tap
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    'assets/home-icons/Unorder list.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
