import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class SlideRevealAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const SlideRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<SlideRevealAnimation> createState() => SlideRevealAnimationState();
}

class SlideRevealAnimationState extends State<SlideRevealAnimation> {
  Timer? timer;
  String scramble = '';

  final chars = ['#', '@', '%', '&', '*', '\$', '!', '?'];

  String generate(int length) {
    final rand = Random();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  void startScramble(int length) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!mounted) return;

      setState(() {
        scramble = generate(length);
      });
    });
  }

  void stopScramble() {
    timer?.cancel();
  }

  @override
  void didUpdateWidget(covariant SlideRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stage == 2) {
      startScramble(widget.oldText.length);
    }

    if (widget.stage == 3) {
      stopScramble();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String display;

    if (widget.stage == 2) {
      display = scramble;
    } else if (widget.stage == 3) {
      display = widget.newText;
    } else {
      display = widget.oldText;
    }

    return Text(
      display,
      style: TextStyle(
        fontSize: 34,
        color: HelperFunctions.isDarkMode(context)
            ? Colors.white
            : Colors.black,
      ),
    );
  }
}

