import 'dart:math';
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

class _WishScreenState extends State<WishScreen> with SingleTickerProviderStateMixin {
  late BirthdayController ctl;
  late List<int> randomQuoteIndexes;

  // Animation controller for cake & candle
  late AnimationController _cakeController;
  late Animation<double> _cakeScaleAnimation;

  @override
  void initState() {
    super.initState();
    ctl = context.read<BirthdayController>();

    // start mic detection after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctl.initBlowDetection();
    });

    // Prepare random quote order
    final rand = Random();
    randomQuoteIndexes = List.generate(ctl.quotes.length, (i) => i)..shuffle(rand);

    // Cake animation
    _cakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cakeScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _cakeController, curve: Curves.easeOutBack),
    );

    // Trigger scale animation on candle blow
    ctl.candleLitNotifier.addListener(() {
      if (!ctl.candleLitNotifier.value) {
        _cakeController.forward().then((_) => _cakeController.reverse());
      }
    });
  }

  @override
  void dispose() {
    _cakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        // Romantic gradient: soft pink/purple
        gradientColors: const [Color(0xFFFFD1DC), Color(0xFFB388EB)],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Top row: back + play/pause
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: ctl.songPlayingNotifier,
                      builder: (_, isPlaying, __) {
                        return IconButton(
                          tooltip: isPlaying ? "Pause song" : "Play song",
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 36,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: ctl.togglePlayPause,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Main content
                Expanded(
                  child: Column(
                    children: [
                      // Cake with candle & scale animation
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: ctl.candleLitNotifier,
                            builder: (_, isLit, __) {
                              return ScaleTransition(
                                scale: _cakeScaleAnimation,
                                child: CakeWithCandle(
                                  isCandleLit: isLit,
                                  onManualBlow: ctl.manualBlow,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Blow indicator
                      const BlowIndicator(),

                      const SizedBox(height: 16),

                      // Quotes carousel with fade animation
                      Expanded(
                        flex: 4,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.85),
                          itemCount: ctl.quotes.length,
                          itemBuilder: (_, i) {
                            final randomIndex = randomQuoteIndexes[i % ctl.quotes.length];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 500),
                                child: QuoteCard(
                                  quote: ctl.quotes[randomIndex],
                                  backgroundColor: Colors.white.withOpacity(0.85),
                                  textColor: Colors.pinkAccent.shade700,
                                ),
                              ),
                            );
                          },
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
