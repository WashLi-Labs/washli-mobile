import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentOptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isIconSvg;
  final Widget? trailing;

  const PaymentOptionTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    required this.onTap,
    this.isIconSvg = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
        child: Row(
          children: [
            // Selection Indicator (Radio Button style)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0057E6) : const Color(0xFF0057E6),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0057E6),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 24),

            // Icon
            SizedBox(
              width: 32, 
              height: 32,
              child: isIconSvg 
                ? SvgPicture.asset(iconPath) 
                : Image.asset(iconPath),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Trailing
            trailing ?? const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}
