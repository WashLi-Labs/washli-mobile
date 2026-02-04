import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color iconColor;

  const ActivityButton({
    super.key,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SvgPicture.asset(
            'assets/home-icons/Unorder list.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
