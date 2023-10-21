import 'package:flutter/material.dart';

@immutable
class ImageWithAspectRation {
  final Image image;
  final double aspectRatio;

  const ImageWithAspectRation({
    required this.image,
    required this.aspectRatio,
  });
}
