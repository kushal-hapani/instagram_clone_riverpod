import 'package:instagram_clone_riverpod/views/components/animations/lottie_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/model/lottie_animations.dart';

class EmptyContentAnimationView extends LottieAnimationView {
  const EmptyContentAnimationView({super.key})
      : super(
          animations: LottieAnimations.empty,
        );
}
