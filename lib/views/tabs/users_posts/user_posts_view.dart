import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/user_post_providers.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_content_with_text_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/posts_gridview.dart';
import 'package:instagram_clone_riverpod/views/constants/strings.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(userPostProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: post.when(
        data: (post) {
          if (post.isEmpty) {
            return const EmptyContentWithTextAnimationViewWithText(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return PostGridView(
              posts: post,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationsView();
        },
      ),
    );
  }
}
