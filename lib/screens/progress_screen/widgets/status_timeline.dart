import 'package:flutter/material.dart';

class StatusTimeline extends StatelessWidget {
  final int currentStageIndex;

  const StatusTimeline({super.key, required this.currentStageIndex});

  @override
  Widget build(BuildContext context) {
    final stages = ['Accepted', 'Picked-up', 'Handed-over', 'Ready', 'Delivered'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(stages.length, (index) {
          final isCompleted = index <= currentStageIndex;
          final isLineCompleted = index < currentStageIndex;
          final isFirst = index == 0;
          final isLast = index == stages.length - 1;

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Left Line
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isFirst 
                            ? Colors.transparent 
                            : (isCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300]),
                      ),
                    ),
                    // Circle Node
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300],
                        border: Border.all(
                          color: isCompleted ? const Color(0xFF2ECA7F) : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : const SizedBox(),
                    ),
                    // Right Line
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isLast 
                            ? Colors.transparent 
                            : (isLineCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stages[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

