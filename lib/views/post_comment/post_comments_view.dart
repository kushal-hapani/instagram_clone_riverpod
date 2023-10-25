import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone_riverpod/state/comments/models/post_comment_request.dart';
import 'package:instagram_clone_riverpod/state/comments/providers/post_comments_provider.dart';
import 'package:instagram_clone_riverpod/state/comments/providers/send_comment_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_content_with_text_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/comment/comments_tile.dart';
import 'package:instagram_clone_riverpod/views/constants/strings.dart';
import 'package:instagram_clone_riverpod/views/extensions/dismiss_keyboard.dart';

class PostCommentView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      RequestForPostAndComments(postId: postId),
    );

    final comment = ref.watch(postCommentsProvider(request.value));

    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [commentController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.comments,
        ),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () {
                    _submitCommentWithController(
                      commentController,
                      ref,
                    );
                  }
                : null,
            icon: const Icon(
              Icons.send_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comment.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContentWithTextAnimationViewWithText(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async => await ref.read(
                        postCommentsProvider(request.value),
                      ),
                      child: ListView.builder(
                        itemCount: comments.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final comment = comments.elementAt(index);
                          return CommentTile(
                            comment: comment,
                          );
                        },
                      ),
                    );
                  }
                },
                loading: () {
                  return const LoadingAnimationsView();
                },
                error: (error, stackTrace) {
                  return const ErrorAnimationView();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: commentController,
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(commentController, ref);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }

    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          fromUserId: userId,
          postId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
