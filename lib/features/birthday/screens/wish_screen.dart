import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/birthday_controller.dart';
import '../widgets/gradient_background.dart';
import '../widgets/cake_with_candle.dart';
import '../widgets/blow_indicator.dart';
import '../widgets/quote_card.dart';

class WishScreen extends StatefulWidget {
  const WishScreen({super.key});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> {
  @override
  void initState() {
    super.initState();
    // start mic detection after first frame to ensure permissions dialog doesn’t clash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BirthdayController>().initBlowDetection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctl = context.watch<BirthdayController>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: ctl.isSongPlaying ? "Pause song" : "Play song",
                      icon: Icon(ctl.isSongPlaying ? Icons.pause_circle : Icons.play_circle),
                      onPressed: ctl.togglePlayPause,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Center(child: CakeWithCandle(isCandleLit: ctl.isCandleLit, onManualBlow: ctl.manualBlow)),
                      ),
                      const SizedBox(height: 8),
                      const BlowIndicator(),
                      const SizedBox(height: 16),
                      Expanded(
                        flex: 4,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.9),
                          itemCount: ctl.quotes.length,
                          itemBuilder: (_, i) => QuoteCard(quote: ctl.quotes[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
