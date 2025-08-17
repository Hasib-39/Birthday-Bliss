import 'package:flutter/material.dart';

class CandleWidget extends StatelessWidget {
  final Color candleColor;
  const CandleWidget({super.key, required this.candleColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flame
        Container(
          width: 14,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.yellow, Colors.orange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Wick
        Container(
          width: 2,
          height: 10,
          color: Colors.black,
        ),
        // Candle Body with Stripes
        Container(
          width: 16,
          height: 50,
          decoration: BoxDecoration(
            color: candleColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              5,
                  (index) => Expanded(
                child: Container(
                  color: index.isEven
                      ? candleColor
                      : Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
