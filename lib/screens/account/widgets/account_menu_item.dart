import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const AccountMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
           iconPath,
           width: 24,
           height: 24,
           colorFilter: ColorFilter.mode(
             isDestructive ? Colors.red : const Color(0xFF007DFC),
             BlendMode.srcIn,
           ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : const Color(0xFF2D2D3A),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }
}
