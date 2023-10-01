import 'package:instagram_clone_riverpod/views/components/animations/lottie_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/model/lottie_animations.dart';

class SmallErrorAnimationsView extends LottieAnimationView {
  const SmallErrorAnimationsView({super.key})
      : super(
          animations: LottieAnimations.smallError,
        );
}
