import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/views/components/animations/model/lottie_animations.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimations animations;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView({
    super.key,
    required this.animations,
    this.repeat = true,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) => Lottie.asset(
        animations.fullPath,
        repeat: repeat,
        reverse: reverse,
      );
}

extension GetFullPath on LottieAnimations {
  String get fullPath => 'assets/animations/$name.json';
}
