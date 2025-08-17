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
  late BirthdayController ctl;

  @override
  void initState() {
    super.initState();
    ctl = context.read<BirthdayController>();

    // start mic detection after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctl.initBlowDetection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Top row: back button + play/pause
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    // Use ValueListenableBuilder for instant icon update
                    ValueListenableBuilder<bool>(
                      valueListenable: ctl.songPlayingNotifier,
                      builder: (_, isPlaying, __) {
                        return IconButton(
                          tooltip: isPlaying ? "Pause song" : "Play song",
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 36,
                          ),
                          onPressed: () async {
                            await ctl.togglePlayPause();
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Main content
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: CakeWithCandle(
                            isCandleLit: ctl.isCandleLit,
                            onManualBlow: ctl.manualBlow,
                          ),
                        ),
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
