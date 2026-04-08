import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../utils/services/audio_service.dart';

class DarkGlitchOverlay extends StatefulWidget {
  final Widget child;
  final bool isFlickering;

  const DarkGlitchOverlay({
    super.key,
    required this.child,
    this.isFlickering = false,
  });

  @override
  State<DarkGlitchOverlay> createState() => _DarkGlitchOverlayState();
}

enum _EndFrame {
  none,
  frame1_halfVertical,
  frame2_whiteFull,
  frame3_blueLeft,
  frame4_cropBand,
  frame5_bottomBlack,
}

class _DarkGlitchOverlayState extends State<DarkGlitchOverlay> {
  final Random _random = Random();

  bool _isBlack = false;
  bool _isBlue = false;
  bool _showLines = false;
  bool _showVerticalLine = false;
  bool _showFinalScanLine = false;

  _EndFrame _currentEndFrame = _EndFrame.none;

  List<_GlitchLine> _lines = [];

  // ==========================================================
  // MAIN GLITCH TIMELINE
  // ==========================================================
  Future<void> _startBurst() async {
    // 🔊 Play Glitch Sound
    AudioService.instance.playGlitchSound();

    // 1️⃣ PURE BLACK
    setState(() {
      _isBlack = true;
      _isBlue = false;
      _showLines = false;
      _showVerticalLine = false;
      _currentEndFrame = _EndFrame.none;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // 2️⃣ BLUE FLASH
    setState(() {
      _isBlack = false;
      _isBlue = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    // 3️⃣ BACK TO BLACK
    setState(() {
      _isBlue = false;
      _isBlack = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    // 4️⃣ VERTICAL SIGNAL CORRUPTION
    setState(() {
      _showLines = true;
    });

    final verticalEnd = DateTime.now().millisecondsSinceEpoch + 500;

    while (DateTime.now().millisecondsSinceEpoch < verticalEnd) {
      setState(() {
        _lines = List.generate(
          3 + _random.nextInt(3),
          (_) => _GlitchLine.random(_random),
        );
      });

      await Future.delayed(const Duration(milliseconds: 45));
    }

    setState(() {
      _showLines = false;
      _isBlack = false;
    });

    // 5️⃣ WHITE CRASH
    await Future.delayed(const Duration(milliseconds: 350));

    // 6️⃣ BLACK SNAP
    setState(() {
      _isBlack = true;
    });

    await Future.delayed(const Duration(milliseconds: 200));

    // 7️⃣ SINGLE VERTICAL LINE GLITCH
    setState(() {
      _isBlack = false;
      _showVerticalLine = true;
    });

    await Future.delayed(const Duration(milliseconds: 180));

    setState(() {
      _showVerticalLine = false;
    });

    // ==========================================================
    // 🎬 PLAY ALL CINEMATIC FRAMES (LIKE YOUR IMAGES)
    // ==========================================================

    List<_EndFrame> frames = [
      _EndFrame.frame1_halfVertical,
      _EndFrame.frame2_whiteFull,
      _EndFrame.frame3_blueLeft,
      _EndFrame.frame4_cropBand,
      _EndFrame.frame5_bottomBlack,
    ];

    for (final frame in frames) {
      setState(() {
        _currentEndFrame = frame;
      });

      await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(60)));
    }

    // Final blackout
    setState(() {
      _currentEndFrame = _EndFrame.none;
      _isBlack = true;
    });

    await Future.delayed(const Duration(milliseconds: 150));

    // 🔥 FINAL HORIZONTAL CRT FLASH
    setState(() {
      _isBlack = false;
      _showFinalScanLine = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    // Black again
    setState(() {
      _showFinalScanLine = false;
      _isBlack = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    // Clean restore
    setState(() {
      _isBlack = false;
    });
  }

  @override
  void didUpdateWidget(DarkGlitchOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlickering && !oldWidget.isFlickering) {
      _startBurst();
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            widget.child,

            // BLUE FLASH
            if (_isBlue)
              const Positioned.fill(
                child: ColoredBox(color: Color(0xFF0D47A1)),
              ),

            // BLACK SCREEN
            if (_isBlack)
              const Positioned.fill(child: ColoredBox(color: Colors.black)),

            // VERTICAL CORRUPTION STRIPS
            if (_showLines)
              ..._lines.map((l) {
                return Positioned(
                  left: constraints.maxWidth * l.x,
                  child: Transform.translate(
                    offset: Offset(l.jitter, 0),
                    child: Container(
                      width: constraints.maxWidth * l.width,
                      height: constraints.maxHeight,
                      color: l.color.withValues(alpha: 0.8),
                    ),
                  ),
                );
              }),

            // SINGLE VERTICAL LINE
            if (_showVerticalLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: constraints.maxWidth * (0.4 + _random.nextDouble() * 0.2),
                child: Container(width: 3, color: Colors.black),
              ),

            // FRAME 1 – HALF VERTICAL
            if (_currentEndFrame == _EndFrame.frame1_halfVertical)
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: constraints.maxWidth * 0.5,
                    child: const ColoredBox(color: Colors.black),
                  ),
                  Positioned.fill(
                    child: Transform.translate(
                      offset: const Offset(-6, 0),
                      child: widget.child,
                    ),
                  ),
                ],
              ),

            // FRAME 2 – FULL WHITE
            if (_currentEndFrame == _EndFrame.frame2_whiteFull)
              const Positioned.fill(child: ColoredBox(color: Colors.white)),

            // FRAME 3 – BLUE LEFT GRADIENT
            if (_currentEndFrame == _EndFrame.frame3_blueLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: constraints.maxWidth * 0.4,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D47A1), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

            // FRAME 4 – CROPPED BAND
            // FRAME – VERTICAL CENTER BAND
            if (_currentEndFrame == _EndFrame.frame4_cropBand)
              Stack(
                children: [
                  // Black left side
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: constraints.maxWidth * 0.2,
                    child: const ColoredBox(color: Colors.black),
                  ),

                  // Black right side
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: constraints.maxWidth * 0.2,
                    child: const ColoredBox(color: Colors.black),
                  ),

                  // Visible vertical middle slice
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: ClipRect(
                        child: SizedBox(
                          width: constraints.maxWidth * 0.5,
                          child: Transform.translate(
                            offset: const Offset(-8, 0),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // FRAME 5 – RIGHT SIDE BLACK CUT (VERTICAL)
            if (_currentEndFrame == _EndFrame.frame5_bottomBlack)
              Stack(
                children: [
                  widget.child,

                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: constraints.maxWidth * 0.5,
                    child: const ColoredBox(color: Colors.black),
                  ),
                ],
              ),

            // FINAL CRT SCAN LINE FLASH
            if (_showFinalScanLine)
              Positioned.fill(
                child: Stack(
                  children: [
                    const ColoredBox(color: Colors.black),

                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white,
                              Colors.white.withValues(alpha: 0.9),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

// ==========================================================
// VERTICAL GLITCH MODEL
// ==========================================================

class _GlitchLine {
  final double x;
  final double width;
  final double jitter;
  final Color color;

  _GlitchLine({
    required this.x,
    required this.width,
    required this.jitter,
    required this.color,
  });

  factory _GlitchLine.random(Random r) {
    double widthFactor;
    double jitterAmount;

    int roll = r.nextInt(100);

    // 70% very thin micro lines
    if (roll < 70) {
      widthFactor = 0.002 + r.nextDouble() * 0.004; // 🔥 super thin
      jitterAmount = 6;
    }
    // 20% medium thin lines
    else if (roll < 90) {
      widthFactor = 0.005 + r.nextDouble() * 0.01;
      jitterAmount = 10;
    }
    // 10% slightly thicker burst
    else {
      widthFactor = 0.015 + r.nextDouble() * 0.02;
      jitterAmount = 18;
    }

    Color c;

    if (r.nextInt(10) == 0) {
      c = Colors.red; // rare glitch
    } else if (r.nextBool()) {
      c = const Color(0xFF0D47A1);
    } else {
      c = Colors.white;
    }

    return _GlitchLine(
      x: r.nextDouble(),
      width: widthFactor,
      jitter: r.nextDouble() * jitterAmount - (jitterAmount / 2),
      color: c,
    );
  }
}
