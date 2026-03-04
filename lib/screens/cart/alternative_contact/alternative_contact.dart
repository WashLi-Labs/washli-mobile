import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'contact_popup.dart';

class AlternativeContact extends StatefulWidget {
  const AlternativeContact({super.key});

  @override
  State<AlternativeContact> createState() => _AlternativeContactState();
}

class _AlternativeContactState extends State<AlternativeContact> {
  Contact? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Contact? selected = await showModalBottomSheet<Contact>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const ContactPopup(),
        );
        if (selected != null) {
          setState(() {
            _selectedContact = selected;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEFF3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/phone_plus.svg',
              width: 24,
              height: 24,
               colorFilter: const ColorFilter.mode(
                  Color(0xFF2D2D3A),
                  BlendMode.srcIn,
                ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedContact != null 
                        ? _selectedContact!.displayName
                        : 'Alternative Contact',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedContact != null && _selectedContact!.phones.isNotEmpty
                        ? _selectedContact!.phones.first.number
                        : 'In Case the driver is Unable to reach you',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
               child: Center(
                 child: Icon(
                   _selectedContact != null ? Icons.edit : Icons.add, 
                   size: 16, 
                   color: Colors.black54,
                 ),
               ),
            ),
          ],
        ),
      ),
    );
  }
}
