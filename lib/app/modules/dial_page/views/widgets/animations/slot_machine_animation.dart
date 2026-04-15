import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class SlotMachineRevealAnimation extends StatelessWidget {
  final int stage;
  final String oldText;
  final String newText;

  const SlotMachineRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  Widget build(BuildContext context) {
    // In Covert Mode before trick, oldText has the masked digits, newText has the true typed digits.
    final maxLength = max(oldText.length, newText.length);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxLength, (i) {
          // If a digit doesn't exist yet, pass empty space
          String oldDigit = i < oldText.length ? oldText[i] : "";
          String targetDigit = i < newText.length ? newText[i] : "";

          return SlotMachineReel(
            key: ValueKey("reel_$i"), // Stable key prevents state reset
            oldDigit: oldDigit,
            targetDigit: targetDigit,
            index: i,
            stage: stage,
          );
        }),
      ),
    );
  }
}

class SlotMachineReel extends StatefulWidget {
  final String oldDigit;
  final String targetDigit;
  final int index;
  final int stage;

  const SlotMachineReel({
    super.key,
    required this.oldDigit,
    required this.targetDigit,
    required this.index,
    required this.stage,
  });

  @override
  State<SlotMachineReel> createState() => SlotMachineReelState();
}

class SlotMachineReelState extends State<SlotMachineReel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scrollAnimation;

  // Final definitive buffer for 100% stable rendering
  final List<String> _noiseStrip = [];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scrollAnimation = const AlwaysStoppedAnimation(0.0);
    _generateNoise();
  }

  void _generateNoise() {
    final rand = Random();
    _noiseStrip.clear();
    for (int i = 0; i < 50; i++) {
      _noiseStrip.add(rand.nextInt(10).toString());
    }
  }

  @override
  void didUpdateWidget(covariant SlotMachineReel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Stage 0: Typing - Clean elastic drop-in
    if (widget.stage == 0 && widget.targetDigit != oldWidget.targetDigit) {
      _controller.duration = const Duration(milliseconds: 600);
      _scrollAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      );
      _controller.forward(from: 0);
    }

    // Stage 1 & 2: THE REVEAL - Unified atomic flow
    if (widget.stage == 1 && oldWidget.stage != 1) {
      // TRIGGER REVEAL: A single, uninterrupted path from spin to settle
      final totalDuration = 2500 + (widget.index * 150);
      _controller.duration = Duration(milliseconds: totalDuration);
      
      // We calculate a distance that puts the final digit exactly at center (0.0 offset)
      // distance = (number of full rotations) * (digit height)
      final double spinDistance = -40.0 * (_noiseStrip.length + 10);

      _scrollAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: spinDistance)
              .chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: spinDistance, end: spinDistance - 200)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: spinDistance - 200, end: 0.0)
              .chain(CurveTween(curve: const ElasticOutCurve(0.7))),
          weight: 40,
        ),
      ]).animate(_controller);

      _controller.forward(from: 0).then((_) {
        if (mounted && widget.stage >= 2) HapticFeedback.mediumImpact();
      });
    }

    if (widget.stage == 0 && oldWidget.stage != 0) {
      _controller.stop();
      _scrollAnimation = const AlwaysStoppedAnimation(0.0);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final digitColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: 22,
      height: 50,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: AnimatedBuilder(
        animation: _scrollAnimation,
        builder: (context, child) {
          final double value = _scrollAnimation.value;
          
          // MODULAR RENDERER:
          // We calculate which digit from the noise strip is currently passing through the center.
          // Digits are 40px apart.
          final double centerOffset = value % 40.0;
          final int centerIndex = ((-value) / 40.0).floor();
          
          String current = widget.targetDigit;
          String prev = " ";
          String next = " ";

          if (value < -5) {
             // SPINNING: Cycle through noise strip
             current = _getNoiseDigit(centerIndex);
             prev = _getNoiseDigit(centerIndex - 1);
             next = _getNoiseDigit(centerIndex + 1);
          } else {
             // SETTLING: Smoothly transition to the target digit
             // We use the raw value as offset for the target digit when near 0
             return Stack(
               alignment: Alignment.center,
               children: [
                 _buildCircularDigit(widget.targetDigit, value, 0, digitColor),
               ],
             );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              _buildCircularDigit(current, centerOffset, 0, digitColor),
              _buildCircularDigit(prev, centerOffset, -40, digitColor),
              _buildCircularDigit(next, centerOffset, 40, digitColor),
            ],
          );
        },
      ),
    );
  }

  String _getNoiseDigit(int index) {
    if (_noiseStrip.isEmpty) return " ";
    final modIndex = index.abs() % _noiseStrip.length;
    return _noiseStrip[modIndex];
  }

  Widget _buildCircularDigit(String digit, double offset, double basePos, Color color) {
    final double pos = basePos + offset;
    final double dist = pos.abs();
    if (dist > 50) return const SizedBox.shrink();

    final double normalized = (dist / 50).clamp(0.0, 1.0);
    final double scale = 1.0 - (normalized * 0.2);
    final double opacity = 1.0 - (normalized * 0.9);
    final double perspective = (pos / 150).clamp(-0.5, 0.5);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..translate(0.0, pos, 0.0)
        ..rotateX(perspective)
        ..scale(scale),
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: _buildDigit(digit, color),
      ),
    );
  }

  Widget _buildDigit(String d, Color color) {
    return SizedBox(
      height: 40,
      width: 25,
      child: Center(
        child: Text(
          d,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Display',
            color: color,
          ),
        ),
      ),
    );
  }
}

