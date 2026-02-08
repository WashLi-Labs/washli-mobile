import 'package:flutter/material.dart';
import 'package:washli_mobile/widgets/buttons/add_button.dart';


class ServicePopup extends StatefulWidget {
  final String title;
  final String price;
  final String description;

  const ServicePopup({
    super.key,
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  State<ServicePopup> createState() => _ServicePopupState();
}

class _ServicePopupState extends State<ServicePopup> {
  int _count = 1;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count > 1) {
      setState(() {
        _count--;
      });
    } else {
      setState(() {
        isAddedState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/service image.png',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Fee : ${widget.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildQuantityButton(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuantityButton() {
    return AddButton(
      isCounterMode: isAddedState,
      count: _count,
      onDecrement: _decrement,
      onIncrement: _increment,
      onTap: () {
        setState(() {
          isAddedState = true;
          _count = 1;
        });
      },
    );
  }

  bool isAddedState = false; // Add this state variable to the class
}

