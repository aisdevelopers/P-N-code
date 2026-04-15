import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class DigitSequenceAnimation extends StatelessWidget {
  final int stage;
  final String oldDigits;
  final String newDigits;

  const DigitSequenceAnimation({
    required this.stage,
    required this.oldDigits,
    required this.newDigits,
  });

  @override
  Widget build(BuildContext context) {
    final digits = stage == 2
        ? newDigits.split('') // real typed digits
        : oldDigits.split(''); // fake digits (saved number pattern)

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        digits.length,
        (i) => DigitAnimator(digit: digits[i], index: i, stage: stage),
      ),
    );
  }
}

class DigitAnimator extends StatefulWidget {
  final String digit;
  final int index;
  final int stage;

  const DigitAnimator({
    required this.digit,
    required this.index,
    required this.stage,
  });

  @override
  State<DigitAnimator> createState() => DigitAnimatorState();
}

class DigitAnimatorState extends State<DigitAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> offset;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    offset = Tween<double>(
      begin: 0,
      end: -200,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    opacity = Tween<double>(begin: 1, end: 0).animate(controller);
  }

  @override
  void didUpdateWidget(covariant DigitAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stage == 1) {
      Future.delayed(Duration(milliseconds: widget.index * 180), () {
        if (mounted) controller.forward();
      });
    }

    if (widget.stage == 2) {
      controller.value = 1;

      Future.delayed(Duration(milliseconds: widget.index * 180), () {
        if (mounted) controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, offset.value),
          child: Opacity(
            opacity: widget.stage == 1 ? opacity.value : 1,
            child: child,
          ),
        );
      },
      child: Text(
        widget.digit,
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

