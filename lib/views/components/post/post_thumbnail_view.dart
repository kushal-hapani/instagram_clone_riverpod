import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  const PostThumbnailView({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: post.thumbnailUrl,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
