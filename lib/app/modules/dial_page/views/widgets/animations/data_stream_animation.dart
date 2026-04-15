import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class DataStreamRevealAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const DataStreamRevealAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<DataStreamRevealAnimation> createState() =>
      DataStreamRevealAnimationState();
}

class DataStreamRevealAnimationState
    extends State<DataStreamRevealAnimation> {
  final List<RainDrop> _rainDrops = [];
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
        RainDrop(
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
  void didUpdateWidget(covariant DataStreamRevealAnimation oldWidget) {
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
                return DataStreamColumn(
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

class DataStreamColumn extends StatefulWidget {
  final String digit;
  final int index;
  final int stage;

  const DataStreamColumn({
    required this.digit,
    required this.index,
    required this.stage,
  });

  @override
  State<DataStreamColumn> createState() => DataStreamColumnState();
}

class DataStreamColumnState extends State<DataStreamColumn>
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
  void didUpdateWidget(covariant DataStreamColumn oldWidget) {
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

class RainDrop {
  double x;
  double y;
  double speed;
  double opacity;
  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
  });
}

