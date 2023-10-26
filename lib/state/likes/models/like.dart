import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_riverpod/state/constants/firebase_field_names.dart';

import '../../posts/typedefs/post_id.dart';
import '../../posts/typedefs/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likeBy,
    required DateTime dateTime,
  }) : super(
          {
            FirebaseFieldName.postId: postId,
            FirebaseFieldName.userId: likeBy,
            FirebaseFieldName.date: dateTime.toIso8601String(),
          },
        );
}
