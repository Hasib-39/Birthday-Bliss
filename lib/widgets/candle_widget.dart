import 'package:flutter/material.dart';

class CandleWidget extends StatelessWidget {
  const CandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flame
        Container(
          width: 12,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        // Wick
        Container(
          width: 2,
          height: 10,
          color: Colors.black,
        ),
        // Candle Body
        Container(
          width: 16,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
