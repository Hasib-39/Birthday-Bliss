import 'dart:async';
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
  late AnimationController _cakeController;
  late Animation<double> _cakeScaleAnimation;

  // Page controller for quotes
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    ctl = context.read<BirthdayController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctl.initBlowDetection();
    });

    final rand = Random();
    randomQuoteIndexes = List.generate(ctl.quotes.length, (i) => i)..shuffle(rand);

    _cakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cakeScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _cakeController, curve: Curves.easeOutBack),
    );

    ctl.candleLitNotifier.addListener(() {
      if (!ctl.candleLitNotifier.value) {
        _cakeController.forward().then((_) => _cakeController.reverse());
      }
    });

    // Initialize page controller
    _pageController = PageController(viewportFraction: 0.85);

    // Start auto-scrolling quotes
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page!.toInt() + 1) % ctl.quotes.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _cakeController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradientColors: const [Color(0xFFFFD1DC), Color(0xFFB388EB)],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
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
                Expanded(
                  child: Column(
                    children: [
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
                      const BlowIndicator(),
                      const SizedBox(height: 16),
                      Expanded(
                        flex: 4,
                        child: PageView.builder(
                          controller: _pageController,
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
                                  backgroundColor: Colors.white.withValues(alpha: 0.85),
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
