import 'dart:ui';

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
              if (controller.revealAnswer || controller.mode == 'Time Mode') {
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
                } // FADE
                else if (controller.animationType ==
                    AnimationsType.scaleAnimation) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final scale = 0.3 + (value * 0.7);
                      final blur = (1 - value) * 6;
                      final yOffset = (1 - value) * 40;

                      return Transform.translate(
                        offset: Offset(0, yOffset),
                        child: Transform.scale(
                          scale: scale,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: blur,
                              sigmaY: blur,
                            ),
                            child: Opacity(opacity: value, child: child),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      controller.displayNumber,
                      style: TextStyle(
                        fontSize: 34,
                        color: HelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                } else if (controller.animationType ==
                    AnimationsType.slideAnimation) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final yOffset = (1 - value) * 80;
                      final blur = (1 - value) * 8;
                      final opacity = value;

                      return Transform.translate(
                        offset: Offset(0, yOffset),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: blur,
                            sigmaY: blur,
                          ),
                          child: Opacity(opacity: opacity, child: child),
                        ),
                      );
                    },
                    child: Text(
                      controller.displayNumber,
                      style: TextStyle(
                        fontSize: 34,
                        color: HelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
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
                }
                // BOUNCE
                else if (controller.animationType ==
                    AnimationsType.bounceAnimation) {
                  return TweenAnimationBuilder(
                    tween: Tween(begin: 0.8, end: 1.0),
                    curve: Curves.elasticOut,
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Text(
                      controller.displayNumber,
                      style: TextStyle(
                        fontSize: 34,
                        color: HelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                }
                // FLICKER
                else if (controller.animationType ==
                    AnimationsType.flickerAnimation) {
                  return Obx(() {
                    return TweenAnimationBuilder(
                      tween: Tween(
                        begin: 1.0,
                        end: controller.shouldFlicker ? 0.2 : 1.0,
                      ),
                      duration: const Duration(milliseconds: 80),
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Text(
                        controller.displayNumber,
                        style: TextStyle(
                          fontSize: 34,
                          color: HelperFunctions.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  });
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
