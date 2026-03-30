import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui' as dart_ui;
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
                  controller.animationType == AnimationsType.slotMachineAnimation ||
                  controller.animationType == AnimationsType.scrambleAnimation ||
                  controller.animationType == AnimationsType.typewriterAnimation ||
                  controller.animationType == AnimationsType.waveAnimation ||
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
                    AnimationsType.slideAnimation) {
                  return _SlideRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
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
                } else if (controller.animationType ==
                    AnimationsType.slotMachineAnimation) {
                  return _SlotMachineRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
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

class _SlideRevealAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _SlideRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<_SlideRevealAnimation> createState() => _SlideRevealAnimationState();
}

class _SlideRevealAnimationState extends State<_SlideRevealAnimation> {
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
  void didUpdateWidget(covariant _SlideRevealAnimation oldWidget) {
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

class _SlotMachineRevealAnimation extends StatelessWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _SlotMachineRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  Widget build(BuildContext context) {
    // Always use newText (real digits) during typing and early stages
    // as per user request to show real digits instead of the covert mapping.
    final String currentTargetText = newText;
    final maxLength = max(oldText.length, newText.length);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          maxLength,
          (i) {
            String digit = i < currentTargetText.length ? currentTargetText[i] : "";

            return _SlotMachineReel(
              digit: digit,
              index: i,
              stage: stage,
            );
          },
        ),
      ),
    );
  }
}

class _SlotMachineReel extends StatefulWidget {
  final String digit;
  final int index;
  final int stage;

  const _SlotMachineReel({
    required this.digit,
    required this.index,
    required this.stage,
  });

  @override
  State<_SlotMachineReel> createState() => _SlotMachineReelState();
}

class _SlotMachineReelState extends State<_SlotMachineReel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scrollAnimation;

  final List<String> _reelDigits = [];
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();

    _setupReel();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scrollAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _setupReel() {
    _reelDigits.clear();
    final rand = Random();
    for (int i = 0; i < 20; i++) {
      _reelDigits.add(rand.nextInt(10).toString());
    }
    _reelDigits.add(widget.digit.isEmpty ? " " : widget.digit);
  }

  void _triggerEntrySpin() {
    _isLocked = false;
    _controller.duration = const Duration(milliseconds: 800);
    
    // Calculate position for the final digit
    double targetPos = -(_reelDigits.length - 1) * 40.0;
    
    _scrollAnimation = Tween<double>(
      begin: 0, // Start slightly above or at top
      end: targetPos,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward(from: 0).then((_) {
      if (mounted) {
        setState(() => _isLocked = true);
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SlotMachineReel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the target digit changed (common during reveal tricks or peeking)
    if (widget.digit != oldWidget.digit) {
      _setupReel();
      
      // We only trigger an immediate spin if we're NOT currently performing a reveal trick (Stages 1 & 2)
      // Transitions into Stage 2 (Locking) have their own coordinated delayed settlement logic below.
      if (widget.stage == 0) {
        _triggerEntrySpin();
      }
    }

    if (widget.stage == 1 && oldWidget.stage != 1) {
      // PHASE 1: CHAOTIC SPINNING
      _isLocked = false;
      _controller.duration = const Duration(milliseconds: 400);
      _scrollAnimation = Tween<double>(
        begin: 0,
        end: -10 * 40.0, // Scroll down many digits
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      _controller.repeat();
    } else if (widget.stage == 2 && oldWidget.stage != 2) {
      // PHASE 2: SEQUENTIAL LOCKING
      final delay = widget.index * 200; // Left-to-right mechanical delay

      Future.delayed(Duration(milliseconds: delay), () {
        if (!mounted) return;

        _controller.stop();
        _controller.duration = const Duration(milliseconds: 800);

        // Calculate final position: we want the last element to be centered
        double targetPos = -(_reelDigits.length - 1) * 40.0;

        _scrollAnimation = Tween<double>(
          begin: _scrollAnimation.value % 40.0, // Start from current tick
          end: targetPos,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

        _controller.forward(from: 0).then((_) {
          if (mounted) {
            setState(() => _isLocked = true);
            HapticFeedback.lightImpact();
          }
        });
      });
    } else if (widget.stage == 3 && oldWidget.stage != 3) {
      // FORCE LOCK (if skipped)
      _isLocked = true;
      setState(() {});
    } else if (widget.stage == 0 && oldWidget.stage != 0) {
      // RESET
      _isLocked = false;
      _controller.stop();
      _controller.value = 0;
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

    // Dynamic color and glow
    Color digitColor = _isLocked ? const Color(0xFF39FF14) : (isDark ? Colors.white : Colors.black);

    return Container(
      width: 28,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // THE REEL STRIP
            AnimatedBuilder(
              animation: _scrollAnimation,
              builder: (context, child) {
                // Apply blur effect during spin
                double blurAmount = _controller.isAnimating && !_isLocked ? 1.5 : 0.0;

                return ImageFiltered(
                  imageFilter: dart_ui.ImageFilter.blur(sigmaY: blurAmount),
                  child: Transform.translate(
                    offset: Offset(0, _scrollAnimation.value),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _reelDigits.map((d) => _buildDigit(d, digitColor)).toList(),
                    ),
                  ),
                );
              },
            ),

            // CYLINDRICAL SHADING (Gradients at top and bottom to create depth)
            PointerIgnore(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      isDark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.25, 0.75, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            fontWeight: _isLocked ? FontWeight.bold : FontWeight.w400,
            fontFamily: '.SF Pro Display',
            color: color,
            shadows: _isLocked
                ? [
                    const BoxShadow(
                      color: Color(0xAA39FF14),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
class PointerIgnore extends StatelessWidget {
  final Widget child;
  const PointerIgnore({required this.child, super.key});
  @override
  Widget build(BuildContext context) => IgnorePointer(child: child);
}

