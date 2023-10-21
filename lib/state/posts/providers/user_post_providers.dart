import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/main.dart';
import 'package:instagram_clone_riverpod/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_field_names.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post_keys.dart';

final userPostProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  "init UserPostProvider".log();

  final userId = ref.watch(userIdProvider);

  controller.onListen = () {
    controller.sink.add([]);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .where(PostKey.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final document = snapshot.docs;

    "document length ${document.length}".log();
    final posts = document.where((doc) => !doc.metadata.hasPendingWrites).map(
          (e) => Post(
            postId: e.id,
            json: e.data(),
          ),
        );

    "post length -> ${posts.length}".log();

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();

    "DISPOSE".log();
    controller.close();
  });

  return controller.stream;
});
