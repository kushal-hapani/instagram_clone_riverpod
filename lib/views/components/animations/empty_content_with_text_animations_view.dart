import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_content_animation_view.dart';

class EmptyContentWithTextAnimationViewWithText extends StatelessWidget {
  final String text;
  const EmptyContentWithTextAnimationViewWithText(
      {super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ///
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white54),
            ),
          ),

          const EmptyContentAnimationView(),
        ],
      ),
    );
  }
}
