import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/likes/providers/post_like_count_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone_riverpod/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikeCountProvider(postId));

    return likesCount.when(
      data: (likesCount) {
        final personOrPeople =
            likesCount == 1 ? Strings.person : Strings.people;
        final likeCount = '$likesCount $personOrPeople ${Strings.likedThis}';

        return Text(
          likeCount,
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return SmallErrorAnimationsView();
      },
    );
  }
}
