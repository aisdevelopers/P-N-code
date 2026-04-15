import "dart:async";
import "dart:math";
import "dart:ui" as dart_ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "../../../../../utils/helper_functions.dart";

class DigitCloneFloodAnimation extends StatefulWidget {
  final int stage;
  final String oldText;
  final String newText;

  const DigitCloneFloodAnimation({
    required this.stage,
    required this.oldText,
    required this.newText,
  });

  @override
  State<DigitCloneFloodAnimation> createState() =>
      DigitCloneFloodAnimationState();
}

class DigitCloneFloodAnimationState extends State<DigitCloneFloodAnimation> {
  final List<CloneModel> _clones = [];
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
        CloneModel(id: i, offset: Offset.zero, opacity: 0.0, scale: 1.0),
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
  void didUpdateWidget(covariant DigitCloneFloodAnimation oldWidget) {
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

class CloneModel {
  final int id;
  Offset offset;
  double opacity;
  double scale;

  CloneModel({
    required this.id,
    required this.offset,
    required this.opacity,
    required this.scale,
  });
}

