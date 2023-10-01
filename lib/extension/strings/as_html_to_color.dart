import 'dart:ui';

import 'package:instagram_clone_riverpod/extension/strings/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', "#"]).padLeft(8, "ff"),
          radix: 16,
        ),
      );
}
