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
                  controller.revealAnswer ||
                  controller.fadeStage.value > 0) {
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
                    AnimationsType.dataStreamAnimation) {
                  return _DataStreamRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.slotMachineAnimation) {
                  return _SlotMachineRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.digitCloneFlood) {
                  return _DigitCloneFloodAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.digitShuffleDeckAnimation) {
                  return _DigitShuffleDeckAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                }
              }

              // REFACTOR: Avoid snapping by using persistent widgets for complex animations
              if (controller.animationType == AnimationsType.slotMachineAnimation) {
                return _SlotMachineRevealAnimation(
                  stage: controller.fadeStage.value,
                  oldText: controller.displayText,
                  newText: controller.displayNumber,
                );
              } else if (controller.animationType == AnimationsType.digitCloneFlood) {
                return _DigitCloneFloodAnimation(
                  stage: controller.fadeStage.value,
                  oldText: controller.displayText,
                  newText: controller.displayNumber,
                );
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

          return _SlotMachineReel(
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

class _SlotMachineReel extends StatefulWidget {
  final String oldDigit;
  final String targetDigit;
  final int index;
  final int stage;

  const _SlotMachineReel({
    super.key,
    required this.oldDigit,
    required this.targetDigit,
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
  void didUpdateWidget(covariant _SlotMachineReel oldWidget) {
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

class _DataStreamRevealAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _DataStreamRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<_DataStreamRevealAnimation> createState() =>
      _DataStreamRevealAnimationState();
}

class _DataStreamRevealAnimationState
    extends State<_DataStreamRevealAnimation> {
  final List<_RainDrop> _rainDrops = [];
  Timer? _rainTimer;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _setupRain();
  }

  void _setupRain() {
    _rainDrops.clear();
    // OPTIMIZED DATA STORM (120 Drops for smooth performance)
    for (int i = 0; i < 120; i++) {
      _rainDrops.add(
        _RainDrop(
          x: _rand.nextDouble() * Get.width,
          y: _rand.nextDouble() * -800, // Even wider spawn range
          speed: 4.0 + (_rand.nextDouble() * 8.0),
          opacity: 0.1 + (_rand.nextDouble() * 0.6),
        ),
      );
    }
  }

  void _startRain() {
    _rainTimer?.cancel();
    _rainTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        for (var drop in _rainDrops) {
          drop.y += drop.speed;
          if (drop.y > 800) {
            drop.y = -100;
            drop.x = _rand.nextDouble() * Get.width;
          }
        }
      });
    });
  }

  void _stopRain() {
    _rainTimer?.cancel();
    _rainTimer = null;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant _DataStreamRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.stage == 1 || widget.stage == 2) && _rainTimer == null) {
      _startRain();
    } else if (widget.stage == 4 || widget.stage == 0) {
      _stopRain();
    }
  }

  @override
  void dispose() {
    _rainTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentTargetText = widget.stage < 3
        ? widget.oldText
        : widget.newText;
    final maxLength = max(widget.oldText.length, widget.newText.length);

    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // GLOBAL RAIN BACKGROUND (Denser and with heads)
          if (_rainTimer != null)
            ShaderMask(
              shaderCallback: (rect) {
                // Alpha fade-out at the bottom
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.75, 1.0], // Slightly earlier fade to prevent line
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Stack(
                clipBehavior: Clip.none,
                children: _rainDrops.map((drop) {
                  // Position relative to dialer area
                  // Offset adjusted to -400 to ensure heads transition through the mask
                  final double relativeY = (drop.y - 650).clamp(0, 60) / 60;
                  double localBlur = 0.0;
                  if (relativeY > 0.90) {
                    // Blur slightly earlier
                    localBlur = ((relativeY - 0.90) / 0.10) * 10.0;
                  }

                  return Positioned(
                    left: drop.x,
                    top: drop.y - 400, // Adjusted offset
                    child: ImageFiltered(
                      imageFilter: dart_ui.ImageFilter.blur(
                        sigmaY: localBlur,
                        sigmaX: localBlur / 2,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // FAINT TRAIL
                          Opacity(
                            opacity: drop.opacity * 0.5,
                            child: Text(
                              _rand.nextInt(10).toString(),
                              style: const TextStyle(
                                color: Color(0xFF39FF14),
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          // BRIGHT LEADING HEAD
                          Opacity(
                            opacity: drop.opacity,
                            child: Text(
                              _rand.nextInt(10).toString(),
                              style: TextStyle(
                                color: const Color(0xFF39FF14),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xFF39FF14,
                                    ).withOpacity(0.8),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // THE DIGITS
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxLength, (i) {
                String digit = i < currentTargetText.length
                    ? currentTargetText[i]
                    : "";
                return _DataStreamColumn(
                  digit: digit,
                  index: i,
                  stage: widget.stage,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataStreamColumn extends StatefulWidget {
  final String digit;
  final int index;
  final int stage;

  const _DataStreamColumn({
    required this.digit,
    required this.index,
    required this.stage,
  });

  @override
  State<_DataStreamColumn> createState() => _DataStreamColumnState();
}

class _DataStreamColumnState extends State<_DataStreamColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _flickerTimer;
  String _currentRandomDigit = "0";
  bool _isLocked = false;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Slower pulse
    )..repeat(reverse: true);

    _currentRandomDigit = widget.digit.isEmpty ? " " : widget.digit;
    if (widget.stage == 0 || widget.stage == 4) {
      _isLocked = true;
    }
  }

  void _startFlicker() {
    _flickerTimer?.cancel();
    _isLocked = false;
    _flickerTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;
      setState(() {
        _currentRandomDigit = _rand.nextInt(10).toString();
      });
    });
  }

  void _stopFlicker() {
    _flickerTimer?.cancel();
    _flickerTimer = null;
    setState(() {
      _isLocked = true;
      _currentRandomDigit = widget.digit.isEmpty ? " " : widget.digit;
    });
  }

  @override
  void didUpdateWidget(covariant _DataStreamColumn oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.digit != oldWidget.digit && widget.stage == 0) {
      _currentRandomDigit = widget.digit;
    }

    if (widget.stage == 1 && oldWidget.stage != 1) {
      _startFlicker();
    } else if (widget.stage == 2 && oldWidget.stage != 2) {
      if (_flickerTimer == null) _startFlicker();
    } else if (widget.stage == 3 && oldWidget.stage != 3) {
      final delay = widget.index * 150;
      Future.delayed(Duration(milliseconds: delay), () {
        if (mounted) _stopFlicker();
      });
    } else if (widget.stage == 4 && oldWidget.stage != 4) {
      HapticFeedback.lightImpact();
    } else if (widget.stage == 0 && oldWidget.stage != 0) {
      _stopFlicker();
      _isLocked = true;
    }
  }

  @override
  void dispose() {
    _flickerTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color matrixGreen = const Color(0xFF39FF14);
    final Color finalColor = isDark ? Colors.white : Colors.black;

    final bool useNormalColor = _isLocked || widget.stage == 0;

    return Container(
      width: 22, // Tighter Apple-like spacing
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // NO PERMANENT SOFT GLOW (Removed to eliminate background artifacts)

                // MAIN DIGIT
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 1.0,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: useNormalColor
                          ? FontWeight.w400
                          : FontWeight.w300,
                      color: useNormalColor ? finalColor : matrixGreen,
                      fontFamily: '.SF Pro Display',
                      shadows: useNormalColor
                          ? (_isLocked && widget.stage == 4
                                ? [
                                    Shadow(
                                      color: finalColor.withOpacity(
                                        0.3 + (_pulseController.value * 0.3),
                                      ),
                                      blurRadius:
                                          5 + (_pulseController.value * 5),
                                    ),
                                  ]
                                : [])
                          : [], // Removed green matrix glow
                    ),
                    child: Text(_currentRandomDigit),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RainDrop {
  double x;
  double y;
  double speed;
  double opacity;
  _RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
  });
}

class _DigitShuffleDeckAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _DigitShuffleDeckAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<_DigitShuffleDeckAnimation> createState() =>
      _DigitShuffleDeckAnimationState();
}

class _DigitShuffleDeckAnimationState
    extends State<_DigitShuffleDeckAnimation> {
  late List<_CardStateModel> _cards;
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
      return _CardStateModel(
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
  void didUpdateWidget(covariant _DigitShuffleDeckAnimation oldWidget) {
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
            return _ShuffleCard(
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

class _CardStateModel {
  String digit;
  String? finalDigit;
  String? flickerDigit;
  int originalIndex;
  double currentIndex;
  double targetIndex;

  _CardStateModel({
    required this.digit,
    required this.originalIndex,
    required this.currentIndex,
    required this.targetIndex,
  });
}

class _ShuffleCard extends StatelessWidget {
  final _CardStateModel state;
  final int stage;
  final double digitWidth;

  const _ShuffleCard({
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

class _DigitCloneFloodAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const _DigitCloneFloodAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<_DigitCloneFloodAnimation> createState() =>
      _DigitCloneFloodAnimationState();
}

class _DigitCloneFloodAnimationState extends State<_DigitCloneFloodAnimation> {
  final List<_CloneModel> _clones = [];
  final Random _rand = Random();
  Timer? _chaosTimer;
  String _currentCloneDigit = "";

  // Freeze values to prevent premature reveal
  String _frozenOldText = "";
  String _frozenNewText = "";

  @override
  void initState() {
    super.initState();
    _frozenOldText = widget.oldText;
    _frozenNewText = widget.newText;
    _setupClones();
  }

  void _setupClones() {
    _clones.clear();
    // 25 Clones for a more dense "Flood" effect
    for (int i = 0; i < 25; i++) {
      _clones.add(
        _CloneModel(id: i, offset: Offset.zero, opacity: 0.0, scale: 1.0),
      );
    }
  }

  void _startChaos() {
    _chaosTimer?.cancel();
    _chaosTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;
      setState(() {
        for (var clone in _clones) {
          // Intense chaotic movement during Stage 2 (Flood)
          clone.offset = Offset(
            (_rand.nextDouble() - 0.5) * Get.width * 0.9,
            (_rand.nextDouble() - 0.5) * Get.height * 0.3,
          );
          clone.opacity = 0.2 + (_rand.nextDouble() * 0.7);
          clone.scale = 0.5 + (_rand.nextDouble() * 1.5);

          // Flicker digits randomly
          if (_rand.nextBool()) {
            _currentCloneDigit = List.generate(
              _frozenOldText.length,
              (_) => _rand.nextInt(10).toString(),
            ).join();
          }
        }
      });
    });
  }

  void _stopChaos() {
    _chaosTimer?.cancel();
    _chaosTimer = null;
  }

  @override
  void didUpdateWidget(covariant _DigitCloneFloodAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stage == 1 && oldWidget.stage != 1) {
      // FREEZE values at start of animation
      _frozenOldText = widget.oldText;
      _frozenNewText = widget.newText;

      // STAGGERED CLONING (Digits peel away layers)
      for (int i = 0; i < _clones.length; i++) {
        Future.delayed(Duration(milliseconds: i * 15), () {
          if (!mounted || widget.stage != 1) return;
          setState(() {
            _clones[i].opacity = i < 10 ? 0.4 : 0.0;
            _clones[i].offset = Offset(
              (_rand.nextDouble() - 0.5) * 40.0,
              (_rand.nextDouble() - 0.5) * 40.0,
            );
            _clones[i].scale = 1.05;
          });
        });
      }
    } else if (widget.stage == 2 && oldWidget.stage != 2) {
      // Update frozen new text if it changed in the controller (like when displayNumber = saved happens)
      if (widget.newText != _frozenNewText) {
        _frozenNewText = widget.newText;
      }

      // SYSTEM OVERLOAD / FLOOD (Primary number disappears into chaos)
      _startChaos();
    } else if (widget.stage == 3 && oldWidget.stage != 3) {
      // COLLAPSE (Clones merge back to center)
      _stopChaos();
      setState(() {
        for (var clone in _clones) {
          clone.offset = Offset.zero;
          clone.opacity = 0.0;
          clone.scale = 1.0;
        }
      });
    } else if (widget.stage == 0 && oldWidget.stage != 0) {
      _stopChaos();
      _setupClones();
      _frozenOldText = widget.oldText;
      _frozenNewText = widget.newText;
    }
  }

  @override
  void dispose() {
    _chaosTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color textColor = isDark ? Colors.white : Colors.black;

    // Choose which text to show on clones
    // On Stage 1 & 2, clones look like the OLD text or random noise.
    // On Stage 3, they become the NEW text as they merge.
    String cloneText;
    if (widget.stage <= 2) {
      cloneText = _chaosTimer != null ? _currentCloneDigit : _frozenOldText;
    } else {
      cloneText = _frozenNewText;
    }

    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // THE CLONES (FLOOD LAYERS)
          if (widget.stage > 0 && widget.stage < 4)
            ..._clones.map(
              (clone) => AnimatedPositioned(
                duration: Duration(milliseconds: widget.stage == 2 ? 60 : 800),
                curve: widget.stage == 1 ? Curves.elasticOut : (widget.stage == 3 ? Curves.elasticOut : Curves.easeInOut),
                left: (Get.width / 2) - 100 + clone.offset.dx,
                top: 10 + clone.offset.dy,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: clone.opacity,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: clone.scale,
                    child: Text(
                      cloneText,
                      style: TextStyle(
                        fontSize: 34,
                        color: widget.stage == 2
                            ? Colors.red.withOpacity(
                                clone.opacity,
                              ) // Red tint for "System Overload"
                            : textColor.withOpacity(0.4),
                        fontFamily: '.SF Pro Display',
                        fontWeight: FontWeight.w300,
                        shadows: widget.stage == 1 ? [
                          Shadow(
                            color: textColor.withOpacity(0.2),
                            blurRadius: 10,
                          )
                        ] : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // THE PRIMARY NUMBER
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: (widget.stage == 1 || widget.stage == 2)
                  ? 0.0
                  : 1.0, // Primary disappears during flood (Stage 1 & 2)
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 34, // Standard size
                  fontWeight: FontWeight.w400, // Standard weight
                  color: textColor,
                  fontFamily: '.SF Pro Display',
                  letterSpacing: (widget.stage == 1) ? 8.0 : 0.0,
                  shadows: [], // Removed glowing shadows
                ),
                child: Text(
                  (widget.stage == 3 || widget.stage == 4) ? _frozenNewText : widget.oldText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CloneModel {
  final int id;
  Offset offset;
  double opacity;
  double scale;

  _CloneModel({
    required this.id,
    required this.offset,
    required this.opacity,
    required this.scale,
  });
}

class PointerIgnore extends StatelessWidget {
  final Widget child;
  const PointerIgnore({required this.child, super.key});
  @override
  Widget build(BuildContext context) => IgnorePointer(child: child);
}
