import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/home-icons/Magnifer.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
