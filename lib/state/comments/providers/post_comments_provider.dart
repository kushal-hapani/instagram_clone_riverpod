import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone_riverpod/state/comments/models/comment.dart';
import 'package:instagram_clone_riverpod/state/comments/models/post_comment_request.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_field_names.dart';

final postCommentsProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<Iterable<Comment>>();

    //Subscribe to Comment collection
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(
          FirebaseFieldName.postId,
          isEqualTo: request.postId,
        )
        .snapshots()
        .listen((snapshot) {
      final documents = snapshot.docs;
      final limitedDocument =
          request.limit != null ? documents.take(request.limit!) : documents;

      final comments =
          limitedDocument.where((doc) => !doc.metadata.hasPendingWrites).map(
                (document) => Comment(
                  id: document.id,
                  document.data(),
                ),
              );

      final result = comments.applySortingFrom(request);

      if (!controller.isClosed) {
        controller.sink.add(result);
      }
    });

    ref.onDispose(() {
      controller.close();
    });

    return controller.stream;
  },
);
