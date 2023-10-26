import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:instagram_clone_riverpod/main.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_riverpod/state/image_upload/constants/constants.dart';
import 'package:instagram_clone_riverpod/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone_riverpod/state/image_upload/extension/get_collection_name_from_file_type.dart';
import 'package:instagram_clone_riverpod/state/image_upload/extension/get_image_data_aspect_ratio.dart';
import 'package:instagram_clone_riverpod/state/image_upload/model/file_type.dart';
import 'package:instagram_clone_riverpod/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone_riverpod/state/post_settings/models/post_setting.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post_payload.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/user_id.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }

        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;

      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumbnailQuality,
        );

        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUint8List = thumb;
        }

        break;
    }

    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    final fileName = const Uuid().v4();

    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //Upload thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //Upload original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalStorageId = originalFileUploadTask.ref.name;

      //Upload the post
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalStorageId,
        postSettings: postSettings,
      );

      //
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);

      return true;
    } on FirebaseException catch (e) {
      'Code ${e.code}'.log();
      'Message ${e.message}?'.log();
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}