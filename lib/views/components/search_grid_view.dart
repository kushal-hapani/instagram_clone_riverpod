import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/post_by_search_term_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/search_term.dart';
import 'package:instagram_clone_riverpod/views/components/animations/data_not_found_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_content_with_text_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_sliver_grid_view.dart';
import 'package:instagram_clone_riverpod/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTerm;
  const SearchGridView({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(searchTermProvider(searchTerm));

    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentWithTextAnimationViewWithText(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }

    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostSliverGridView(
            posts: posts,
          );
        }
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        return const SliverToBoxAdapter(
          child: ErrorAnimationView(),
        );
      },
    );
  }
}
