import 'package:flutter/material.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/shared_layout/comments_screen.dart';

Future<dynamic> commentsButtomSheet(
    {required BuildContext context,
    required Post post,
    required String currentUserId}) {
  return showModalBottomSheet(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      builder: (BuildContext context) {
        return CommentsScreen(postData: post);
      });
}
