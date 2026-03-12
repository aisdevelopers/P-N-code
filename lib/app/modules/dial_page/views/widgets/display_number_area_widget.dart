import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../utils/constants/img_constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../settings/models/animation_type_model.dart';
import '../../controllers/dial_page_controller.dart';

class DisplayNumberAreaWidget extends GetView<DialPageController> {
  const DisplayNumberAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.25,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Obx(() {
              if (controller.showBackSpaceButton) {
                return Image.asset(
                  ImgConstants.addContactIcon,
                  height: 25,
                  width: 25,
                  color: HelperFunctions.isDarkMode(context)
                      ? Colors.white
                      : Colors.black,
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,

            child: Obx(() {
              if (controller.mode == 'Time Mode' ||
                  controller.animationType == AnimationsType.fadeAnimation ||
                  controller.animationType == AnimationsType.scaleAnimation ||
                  controller.animationType == AnimationsType.slideAnimation ||
                  controller.revealAnswer) {
                if (controller.animationType ==
                    AnimationsType.simpleAnimation) {
                  return AutoSizeText(
                    controller.displayNumber,
                    maxLines: 1,
                    minFontSize: 28,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      letterSpacing: 0,
                      color: HelperFunctions.isDarkMode(context)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: '.SF Pro Display',
                      fontSize:
                          controller.displayNumber.length >
                              controller.maxVisible
                          ? 28
                          : 34,
                    ),
                  );
                } else if (controller.animationType ==
                    AnimationsType.typewriterAnimation) {
                  return DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 34,
                      color: HelperFunctions.isDarkMode(context)
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: false,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          controller.displayNumber,
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  );
                } else if (controller.animationType ==
                    AnimationsType.fadeAnimation) {
                  return _DigitSequenceAnimation(
                    stage: controller.fadeStage.value,
                    oldDigits: controller.displayText,
                    newDigits: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.scaleAnimation) {
                  return _SplitRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.waveAnimation) {
                  return AnimatedTextKit(
                    totalRepeatCount: 1,
                    repeatForever: false,
                    animatedTexts: [
                      WavyAnimatedText(
                        controller.displayNumber,
                        textStyle: TextStyle(
                          fontSize: 34,
                          color: HelperFunctions.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  );
                } else if (controller.animationType ==
                    AnimationsType.scrambleAnimation) {
                  // Show Animated Text Widget
                  return DefaultTextStyle(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize:
                          controller.displayNumber.length >
                              controller.maxVisible
                          ? 28
                          : 34,
                      letterSpacing: 0,
                      color: HelperFunctions.isDarkMode(context)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: '.SF Pro Display',
                    ),
                    child: AnimatedTextKit(
                      key: ValueKey(controller.displayNumber),
                      controller: controller.numberAnimationController,
                      repeatForever: false,
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        ScrambleAnimatedText(
                          controller.displayNumber,
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      controller.displayNumber,
                      maxLines: 1,
                      minFontSize: 28,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        letterSpacing: 0,
                        color: HelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: '.SF Pro Display',
                        fontSize:
                            controller.displayNumber.length >
                                controller.maxVisible
                            ? 28
                            : 34,
                      ),
                    ),
                  );
                }
              } else {
                // Show Auto Size Text Widget
                return AutoSizeText(
                  controller.displayText,
                  maxLines: 1,
                  minFontSize: 28,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    letterSpacing: 0,
                    color: HelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: '.SF Pro Display',
                    fontSize:
                        controller.displayNumber.length > controller.maxVisible
                        ? 28
                        : 34,
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class _DigitSequenceAnimation extends StatelessWidget {
  final int stage;
  final String oldDigits;
  final String newDigits;

  const _DigitSequenceAnimation({
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
        (i) => _DigitAnimator(digit: digits[i], index: i, stage: stage),
      ),
    );
  }
}

class _DigitAnimator extends StatefulWidget {
  final String digit;
  final int index;
  final int stage;

  const _DigitAnimator({
    required this.digit,
    required this.index,
    required this.stage,
  });

  @override
  State<_DigitAnimator> createState() => _DigitAnimatorState();
}

class _DigitAnimatorState extends State<_DigitAnimator>
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
  void didUpdateWidget(covariant _DigitAnimator oldWidget) {
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

class _SplitRevealAnimation extends StatelessWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _SplitRevealAnimation({
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
        _HalfAnimator(text: left, isLeft: true, stage: stage),
        _HalfAnimator(text: right, isLeft: false, stage: stage),
      ],
    );
  }
}

class _HalfAnimator extends StatefulWidget {
  final String text;
  final bool isLeft;
  final int stage;

  const _HalfAnimator({
    required this.text,
    required this.isLeft,
    required this.stage,
  });

  @override
  State<_HalfAnimator> createState() => _HalfAnimatorState();
}

class _HalfAnimatorState extends State<_HalfAnimator>
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
  void didUpdateWidget(covariant _HalfAnimator oldWidget) {
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
