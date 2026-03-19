import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:washli_mobile/providers/cart_provider.dart';

class CartItemCard extends ConsumerStatefulWidget {
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
  ConsumerState<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends ConsumerState<CartItemCard> {
  String? _note;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final itemIndex = cart.items.indexWhere((item) => item.title == widget.title);
    final quantity = itemIndex != -1 ? cart.items[itemIndex].quantity : 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0062FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 0) {
                          ref.read(cartProvider.notifier).updateQuantity(widget.title, quantity - 1);
                        }
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
                      onTap: () {
                        ref.read(cartProvider.notifier).updateQuantity(widget.title, quantity + 1);
                      },
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: SvgPicture.asset(
                    'assets/icons/note.svg',
                    width: 16,
                    height: 16,
                     colorFilter: ColorFilter.mode(
                      _note != null && _note!.isNotEmpty ? const Color(0xFF0062FF) : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _note != null && _note!.isNotEmpty ? _note! : 'Add Note',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                      fontSize: 12,
                      color: _note != null && _note!.isNotEmpty ? const Color(0xFF0062FF) : Colors.grey[600],
                    ),
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
          maxLength: 100,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter note (max 100 chars)',
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2688EA)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2688EA)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2688EA)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              noteController.clear();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.grey)),
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
