import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartItemCard extends StatefulWidget {
  final String title;
  final double fee;
  final String type;
  final String service;
  final int initialQuantity;

  const CartItemCard({
    super.key,
    required this.title,
    required this.fee,
    required this.type,
    required this.service,
    this.initialQuantity = 0,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int quantity;
  String? _note;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Add shadow or border if needed, design shows plain white background with separators usually, currently relying on parent structure
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              // Quantity Adjuster
              Container(
                margin: const EdgeInsets.only(top: 4), // Push it down slightly effectively
                decoration: BoxDecoration(
                  color: const Color(0xFF0062FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 0) setState(() => quantity--);
                      },
                      child: const Icon(Icons.remove, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => quantity++),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Reduced spacing
          
          Row(
            children: [
              Text(
                'Fee : LKR ${widget.fee.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Type : ${widget.type}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Service : ${widget.service}',
             style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Add Note
          GestureDetector(
            onTap: _showNoteDialog,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/note.svg',
                  width: 16,
                  height: 16,
                   colorFilter: ColorFilter.mode(
                    _note != null && _note!.isNotEmpty ? const Color(0xFF0062FF) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _note != null && _note!.isNotEmpty ? _note! : 'Add Note',
                   style: TextStyle(
                    fontSize: 12,
                    color: _note != null && _note!.isNotEmpty ? const Color(0xFF0062FF) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFEAEFF3)),
        ],
      ),
    );
  }

  Future<void> _showNoteDialog() async {
    final TextEditingController noteController = TextEditingController(text: _note);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: noteController,
          maxLength: 20,
          decoration: const InputDecoration(
            hintText: 'Enter note (max 20 chars)',
            border: OutlineInputBorder(),
             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _note = noteController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF0062FF))),
          ),
        ],
      ),
    );
  }
}
