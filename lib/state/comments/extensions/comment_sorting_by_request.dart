import 'package:instagram_clone_riverpod/enums/date_sorting.dart';
import 'package:instagram_clone_riverpod/state/comments/models/comment.dart';
import 'package:instagram_clone_riverpod/state/comments/models/post_comment_request.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments = toList()
        ..sort((a, b) {
          switch (request.dateSorting) {
            case DateSorting.newOnTop:
              return b.createdAt.compareTo(a.createdAt);
            case DateSorting.oldOnTop:
              return a.createdAt.compareTo(b.createdAt);
          }
        });
      return sortedDocuments;
    } else {
      return this;
    }
  }
}
