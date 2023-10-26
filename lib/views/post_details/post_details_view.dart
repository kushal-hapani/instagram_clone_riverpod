import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/enums/date_sorting.dart';
import 'package:instagram_clone_riverpod/state/comments/models/post_comment_request.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/delete_post_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/specific_post_with_comment_provider.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/comment/compact_comment_column.dart';
import 'package:instagram_clone_riverpod/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone_riverpod/views/components/dialogs/delete_dialog.dart';
import 'package:instagram_clone_riverpod/views/components/like_button.dart';
import 'package:instagram_clone_riverpod/views/components/likes_count_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_date_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_display_name_and_message.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_image_or_video_view.dart';
import 'package:instagram_clone_riverpod/views/constants/strings.dart';
import 'package:instagram_clone_riverpod/views/post_comment/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldOnTop,
    );

    //Get actual post with comments
    final postWithComment = ref.watch(specificPostWithCommentProvider(request));

    //Can we delete post
    final canDeletePost =
        ref.watch(canCurrentUserDeletePostProvider(widget.post));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          //Share button will always be there
          postWithComment.when(
            data: (postWithComment) {
              return IconButton(
                onPressed: () {
                  final url = postWithComment.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
                icon: const Icon(Icons.share_rounded),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stackTrace) => const SmallErrorAnimationsView(),
          ),

          //Delete button or no delete button
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                  titleOfObjectToDelete: Strings.post,
                ).present(context).then((value) => value ?? false);

                if (shouldDeletePost) {
                  ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              icon: const Icon(Icons.delete_rounded),
            ),
        ],
      ),
      body: postWithComment.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Like button if post allow liking
                    if (postWithComments.post.allowsLikes)
                      LikeButton(
                        postId: postId,
                      ),

                    //Comments button if post allow liking
                    if (postWithComments.post.allowsComments)
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostCommentView(
                                postId: postId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                  ],
                ),

                //Post details
                PostDisplayNameAndMessageView(
                  post: postWithComments.post,
                ),

                PostDateView(
                  dateTime: postWithComments.post.createdAt,
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),

                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),

                if (postWithComments.post.allowsLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(
                          postId: postId,
                        ),
                      ],
                    ),
                  ),

                //
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingAnimationsView(),
        error: (error, stackTrace) => const ErrorAnimationView(),
      ),
    );
  }
}
