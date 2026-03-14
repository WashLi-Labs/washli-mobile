import 'package:flutter/material.dart';

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        isDestructive ? const Color(0xFFE53935) : const Color(0xFF007DFC);
    final Color textColor =
        isDestructive ? const Color(0xFFE53935) : const Color(0xFF1A1A2E);
    final Color bgColor =
        isDestructive ? const Color(0xFFFFEBEE) : const Color(0xFFF7FAFF);
    final Color borderColor =
        isDestructive ? const Color(0xFFFFCDD2) : const Color(0xFFE3EDFF);
    final Color iconBgColor =
        isDestructive ? const Color(0x1FE53935) : const Color(0x1F007DFC); // ~12% opacity
    final Color subtitleColor =
        isDestructive ? const Color(0x8CE53935) : const Color(0x8C1A1A2E); // ~55% opacity
    final Color chevronColor =
        isDestructive ? const Color(0x80E53935) : const Color(0xFFBDBDBD);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 14),

                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Chevron
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: chevronColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
