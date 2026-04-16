import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_glitch/animated_glitch.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui' as dart_ui;
import '../../../../utils/constants/img_constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../settings/models/animation_type_model.dart';
import '../../controllers/dial_page_controller.dart';
import "animations/digit_sequence_animation.dart";
import "animations/split_reveal_animation.dart";
import "animations/slide_reveal_animation.dart";
import "animations/slot_machine_animation.dart";
import "animations/data_stream_animation.dart";
import "animations/digit_clone_flood_animation.dart";
import "animations/digit_shuffle_deck_animation.dart";
import "animations/wave_reveal_animation.dart";

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
                  return SlideRevealAnimation(
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
                  return DigitSequenceAnimation(
                    stage: controller.fadeStage.value,
                    oldDigits: controller.displayText,
                    newDigits: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.scaleAnimation) {
                  return SplitRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.waveAnimation) {
                  return WaveRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
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
                  return DataStreamRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.slotMachineAnimation) {
                  return SlotMachineRevealAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.digitCloneFlood) {
                  return DigitCloneFloodAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.digitShuffleDeckAnimation) {
                  return DigitShuffleDeckAnimation(
                    stage: controller.fadeStage.value,
                    oldText: controller.displayText,
                    newText: controller.displayNumber,
                  );
                } else if (controller.animationType ==
                    AnimationsType.glitchyAnimation) {
                  debugPrint("DEBUG: [DisplayNumberAreaWidget] Rendering glitchyAnimation case");
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: AnimatedGlitch(
                        controller: controller.animatedGlitchController,
                        child: AutoSizeText(
                          controller.displayNumber,
                          maxLines: 1,
                          minFontSize: 28,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0,
                            color: HelperFunctions.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: '.SF Pro Display',
                            fontSize: controller.displayNumber.length >
                                    controller.maxVisible
                                ? 28
                                : 34,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }

              // REFACTOR: Avoid snapping by using persistent widgets for complex animations
              if (controller.animationType == AnimationsType.slotMachineAnimation) {
                return SlotMachineRevealAnimation(
                  stage: controller.fadeStage.value,
                  oldText: controller.displayText,
                  newText: controller.displayNumber,
                );
              } else if (controller.animationType == AnimationsType.digitCloneFlood) {
                return DigitCloneFloodAnimation(
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
