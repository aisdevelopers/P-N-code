import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../utils/helper_functions.dart';

class WaveRevealAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const WaveRevealAnimation({
    super.key,
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<WaveRevealAnimation> createState() => _WaveRevealAnimationState();
}

class _WaveRevealAnimationState extends State<WaveRevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.stage == 1) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(WaveRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stage == 1 && oldWidget.stage != 1) {
      _controller.forward(from: 0.0);
    } else if (widget.stage == 2 && oldWidget.stage != 2) {
      // Stage 2 might be used for settling if needed, 
      // but the current Wave design is a single pass.
    } else if (widget.stage == 0) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int maxLength = max(widget.oldText.length, widget.newText.length);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxLength, (index) {
            return _buildWaveDigit(index, maxLength);
          }),
        );
      },
    );
  }

  Widget _buildWaveDigit(int index, int total) {
    // Wave parameters
    final double progress = _controller.value;
    
    // Each digit starts its wave at different progress points
    // We want the whole wave to finish by progress = 1.0
    // So we use a window.
    final double digitStart = (index / total) * 0.6; // Stagger start points
    final double digitDuration = 0.4; // Duration of one digit's bounce
    
    double digitProgress = (progress - digitStart) / digitDuration;
    digitProgress = digitProgress.clamp(0.0, 1.0);

    // Sinusoidal bounce: goes from 0 -> peak -> 0
    // Using sin(pi * x) gives us a curve from 0 to 1 back to 0 over [0, 1]
    final double waveY = digitProgress > 0 && digitProgress < 1 
        ? sin(pi * digitProgress) 
        : 0.0;

    // Amplitude of the bounce
    const double amplitude = -80.0; // Negative is UP in Flutter
    final double offsetY = waveY * amplitude;

    // Identity switch: flip character at the crest (digitProgress approx 0.5)
    final bool isRevealed = digitProgress > 0.5;
    
    final String charToShow;
    if (isRevealed) {
      charToShow = index < widget.newText.length ? widget.newText[index] : "";
    } else {
      charToShow = index < widget.oldText.length ? widget.oldText[index] : "";
    }

    // Optional: Add a slight scale or opacity effect for extra "juice"
    final double scale = 1.0 + (waveY * 0.2);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Transform.scale(
        scale: scale,
        child: Text(
          charToShow,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Display',
            color: HelperFunctions.isDarkMode(context)
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
