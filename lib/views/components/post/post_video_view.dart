import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animations_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animations_view.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        VideoPlayerController.networkUrl(Uri.parse(post.fileUrl));

    final isVideoPlayerRead = useState(false);

    useEffect(
      () {
        controller.initialize().then((value) {
          isVideoPlayerRead.value = true;
          controller.setLooping(true);
          controller.play();
        });
        return controller.dispose;
      },
      [controller],
    );

    switch (isVideoPlayerRead) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );
      case false:
        return const LoadingAnimationsView();
      default:
        return const ErrorAnimationView();
    }
  }
}