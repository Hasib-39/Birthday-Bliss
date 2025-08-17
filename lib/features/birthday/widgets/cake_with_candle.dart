import 'package:flutter/material.dart';
import '../../../core/assets.dart';

class CakeWithCandle extends StatelessWidget {
  final bool isCandleLit;
  final VoidCallback onManualBlow;

  const CakeWithCandle({
    super.key,
    required this.isCandleLit,
    required this.onManualBlow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onManualBlow, // fallback: long-press to "blow"
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: isCandleLit
            ? Image.asset(
          AppAssets.cakeCandleOn,
          key: const ValueKey('candle_on'),
          fit: BoxFit.contain,
        )
            : Image.asset(
          AppAssets.candleOffGif,
          key: const ValueKey('candle_off'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
