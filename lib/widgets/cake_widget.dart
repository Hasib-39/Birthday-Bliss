import 'package:flutter/material.dart';
import 'candle_widget.dart';

class CakeWidget extends StatelessWidget {
  final bool candlesBlown;
  final Color cakeColor;
  const CakeWidget({
    super.key,
    required this.candlesBlown,
    required this.cakeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Cake Base (Layered)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Frosting layer
            Container(
              width: 220,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            // Main cake body
            Container(
              width: 220,
              height: 100,
              decoration: BoxDecoration(
                color: cakeColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Candles (only if not blown)
        if (!candlesBlown)
          Positioned(
            top: -50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CandleWidget(candleColor: Colors.red),
                SizedBox(width: 16),
                CandleWidget(candleColor: Colors.blue),
                SizedBox(width: 16),
                CandleWidget(candleColor: Colors.green),
              ],
            ),
          ),
      ],
    );
  }
}
