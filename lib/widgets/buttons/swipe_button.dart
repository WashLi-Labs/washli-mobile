import 'package:flutter/material.dart';

class SwipeButton extends StatefulWidget {
  final VoidCallback onSwipe;
  const SwipeButton({super.key, required this.onSwipe});

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double _dragValue = 0.0;
  final double _maxWidth = 200.0; // Reduced width
  final double _buttonSize = 50.0; // Reduced button size
  bool _swiped = false;

  @override
  Widget build(BuildContext context) {
    // Explicit padding for the track
    const double padding = 4.0;
    // Calculate max drag distance based on constants
    final double maxDrag = _maxWidth - _buttonSize - (padding * 2);

    return Container(
      height: 60, // reduced height
      width: _maxWidth,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        // Remove alignment to allow precise positioning
        children: [
          // Centered Text with auto-fade
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0), // Shift text bit right
              child: Opacity(
                opacity: (1.0 - _dragValue).clamp(0.0, 1.0),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          // Slider Button
          Positioned(
            left: padding + (_dragValue * maxDrag),
            top: (60 - _buttonSize) / 2, // Vertically center the button
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (_swiped) return;
                setState(() {
                  double delta = details.primaryDelta! / maxDrag;
                  _dragValue = (_dragValue + delta).clamp(0.0, 1.0);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_swiped) return;
                if (_dragValue > 0.7) { 
                  setState(() {
                    _dragValue = 1.0;
                    _swiped = true;
                  });
                  widget.onSwipe();
                } else {
                  setState(() {
                    _dragValue = 0.0;
                  });
                }
              },
              child: Container(
                height: _buttonSize,
                width: _buttonSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 20, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
