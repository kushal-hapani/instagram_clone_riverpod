import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_riverpod/state/constants/firebase_field_names.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, String> {
  final UserId userId;
  final String displayName;
  final String? email;

  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.email: email!,
          FirebaseFieldName.displayName: displayName,
        });

  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          userId: userId,
          displayName: json[FirebaseFieldName.displayName],
          email: json[FirebaseFieldName.email],
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email! &&
          displayName == other.displayName;

  @override
  int get hashCode => Object.hashAll(
        [
          userId,
          email!,
          displayName,
        ],
      );
}
