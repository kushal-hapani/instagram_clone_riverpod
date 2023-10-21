import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart' as material show Image;
import 'package:instagram_clone_riverpod/state/image_upload/extension/get_image_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() {
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
