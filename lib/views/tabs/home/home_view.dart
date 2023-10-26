import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/all_post_providers.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_content_with_text_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/posts_gridview.dart';

import '../../constants/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPost = ref.watch(allPostProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(allPostProvider),
      child: allPost.when(
        data: (allPost) {
          if (allPost.isEmpty) {
            return const EmptyContentWithTextAnimationViewWithText(
              text: Strings.noPostsAvailable,
            );
          } else {
            return PostGridView(
              posts: allPost,
            );
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const ErrorAnimationView(),
      ),
    );
  }
}
