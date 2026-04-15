import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class SplitRevealAnimation extends StatelessWidget {
  final int stage;
  final String oldText;
  final String newText;

  const SplitRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  Widget build(BuildContext context) {
    final display = stage < 2 ? oldText : newText;

    int mid = (display.length / 2).ceil();

    String left = display.substring(0, mid);
    String right = display.substring(mid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HalfAnimator(text: left, isLeft: true, stage: stage),
        HalfAnimator(text: right, isLeft: false, stage: stage),
      ],
    );
  }
}

class HalfAnimator extends StatefulWidget {
  final String text;
  final bool isLeft;
  final int stage;

  const HalfAnimator({
    required this.text,
    required this.isLeft,
    required this.stage,
  });

  @override
  State<HalfAnimator> createState() => HalfAnimatorState();
}

class HalfAnimatorState extends State<HalfAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> slide;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    slide = Tween<double>(
      begin: 0,
      end: widget.isLeft ? -3000 : 3000,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    opacity = Tween<double>(begin: 1, end: 0).animate(controller);
  }

  @override
  void didUpdateWidget(covariant HalfAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stage == 1) {
      controller.forward();
    }

    if (widget.stage == 2) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(slide.value, 0),
          child: Opacity(
            opacity: widget.stage == 1 ? opacity.value : 1,
            child: child,
          ),
        );
      },
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 34,
          color: HelperFunctions.isDarkMode(context)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}

