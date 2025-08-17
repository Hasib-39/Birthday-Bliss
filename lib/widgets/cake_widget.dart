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
        // Cake Base
        Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            color: cakeColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        if (!candlesBlown)
          const Positioned(
            top: -30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CandleWidget(),
                SizedBox(width: 10),
                CandleWidget(),
                SizedBox(width: 10),
                CandleWidget(),
              ],
            ),
          ),
      ],
    );
  }
}
