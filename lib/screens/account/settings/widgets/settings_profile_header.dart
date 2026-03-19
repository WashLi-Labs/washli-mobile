import 'package:flutter/material.dart';

class SettingsProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? phone;
  final ImageProvider imageProvider;

  const SettingsProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007DFC), Color(0xFF0057E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D007DFC), // 0xFF007DFC at 30% opacity
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xCCFFFFFF), // white 80%
                width: 2.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000), // black 15%
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: imageProvider,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xD9FFFFFF), // white 85%
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (phone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    phone!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xB3FFFFFF), // white 70%
                    ),
                  ),
                ],
              ],
            ),
          ),

        ],
      ),
    );
  }
}
