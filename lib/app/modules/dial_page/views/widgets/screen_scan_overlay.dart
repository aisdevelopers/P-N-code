import 'dart:ui';
import 'package:flutter/material.dart';

class ScanRevealOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const ScanRevealOverlay({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  State<ScanRevealOverlay> createState() => _ScanRevealOverlayState();
}

class _ScanRevealOverlayState extends State<ScanRevealOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(covariant ScanRevealOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.trigger && !isAnimating) {
      isAnimating = true;

      controller.forward(from: 0).then((_) {
        if (mounted) {
          setState(() {
            isAnimating = false;
          });
          controller.reset();
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// When animation finished → return normal UI
    if (!isAnimating) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final blur = (1 - controller.value) * 12;
        final scale = 1 + (1 - controller.value) * 0.04;

        return Stack(
          children: [
            /// UI zoom
            Transform.scale(scale: scale, child: widget.child),

            /// Blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  color: Colors.white.withOpacity(
                    (1 - controller.value) * 0.12,
                  ),
                ),
              ),
            ),

            /// Flash reveal
            if (controller.value > 0.82)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(
                    (controller.value - 0.82) * 3,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

