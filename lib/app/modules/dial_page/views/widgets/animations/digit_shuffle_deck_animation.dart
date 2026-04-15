import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class DigitShuffleDeckAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const DigitShuffleDeckAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<DigitShuffleDeckAnimation> createState() =>
      DigitShuffleDeckAnimationState();
}

class DigitShuffleDeckAnimationState
    extends State<DigitShuffleDeckAnimation> {
  late List<CardStateModel> _cards;
  final Random _rand = Random();
  Timer? _shuffleTimer;

  @override
  void initState() {
    super.initState();
    _setupCards();
  }

  void _setupCards() {
    final text = widget.oldText;
    _cards = List.generate(text.length, (i) {
      return CardStateModel(
        digit: text[i],
        originalIndex: i,
        currentIndex: i.toDouble(),
        targetIndex: i.toDouble(),
      );
    });
  }

  void _startShuffle() {
    _shuffleTimer?.cancel();
    _shuffleTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) return;
      setState(() {
        for (var card in _cards) {
          // Move each card to a random slot within the length range
          card.targetIndex = _rand.nextDouble() * (_cards.length - 1);
          // Randomly flicker identity during shuffle
          if (card.finalDigit != null) {
            card.flickerDigit = _rand.nextBool() ? card.digit : card.finalDigit;
          }
        }
      });
    });
  }

  void _stopShuffle() {
    _shuffleTimer?.cancel();
    _shuffleTimer = null;
  }

  @override
  void didUpdateWidget(covariant DigitShuffleDeckAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stage == 2 && oldWidget.stage != 2) {
      // Begin transformation immediately during shuffle
      setState(() {
        for (int i = 0; i < _cards.length; i++) {
          if (i < widget.newText.length) {
            _cards[i].finalDigit = widget.newText[i];
          }
        }
      });
      _startShuffle();
    } else if (widget.stage == 3 && oldWidget.stage != 3) {
      _stopShuffle();
      // On reorder, snap to final positions
      setState(() {
        for (int i = 0; i < _cards.length; i++) {
          if (i < widget.newText.length) {
            _cards[i].targetIndex = i.toDouble();
          }
        }
      });
    } else if (widget.stage == 0 && oldWidget.stage != 0) {
      _stopShuffle();
      _setupCards();
    }
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digitWidth = 22.0;
    final totalWidth = _cards.length * digitWidth;

    return Center(
      child: SizedBox(
        width: totalWidth,
        height: 60,
        child: Stack(
          clipBehavior: Clip.none,
          children: _cards.map((card) {
            return ShuffleCard(
              state: card,
              stage: widget.stage,
              digitWidth: digitWidth,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CardStateModel {
  String digit;
  String? finalDigit;
  String? flickerDigit;
  int originalIndex;
  double currentIndex;
  double targetIndex;

  CardStateModel({
    required this.digit,
    required this.originalIndex,
    required this.currentIndex,
    required this.targetIndex,
  });
}

class ShuffleCard extends StatelessWidget {
  final CardStateModel state;
  final int stage;
  final double digitWidth;

  const ShuffleCard({
    required this.state,
    required this.stage,
    required this.digitWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color textColor = isDark ? Colors.white : Colors.black;

    // Stage 1: Detach/Lift
    double yOffset = 0;
    double scale = 1.0;
    double shadowOpacity = 0.0;
    double blurAmount = 0.0;

    if (stage >= 1) {
      yOffset = -8;
      scale = 1.08;
      shadowOpacity = 0.2;
    }

    if (stage == 2) {
      blurAmount = 0.8; // Motion blur during shuffle
    }

    if (stage >= 3) {
      yOffset = 0;
      scale = 1.0;
      shadowOpacity = 0.0;
    }

    // Digit reveal logic
    String displayDigit = state.digit;
    if (stage == 2 && state.flickerDigit != null) {
      displayDigit = state.flickerDigit!;
    } else if (stage >= 3 && state.finalDigit != null) {
      displayDigit = state.finalDigit!;
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: stage == 2 ? 150 : 400),
      curve: stage == 3 ? Curves.elasticOut : Curves.easeInOut,
      left: state.targetIndex * digitWidth,
      top: yOffset,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: scale,
        child: ImageFiltered(
          imageFilter: dart_ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: 0),
          child: Container(
            width: digitWidth,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                if (shadowOpacity > 0)
                  BoxShadow(
                    color: Colors.black.withOpacity(shadowOpacity),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Text(
              displayDigit,
              style: TextStyle(
                fontSize: 34,
                fontWeight: stage == 4 ? FontWeight.bold : FontWeight.w400,
                color: textColor,
                fontFamily: '.SF Pro Display',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

