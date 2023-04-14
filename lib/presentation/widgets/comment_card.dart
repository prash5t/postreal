import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/comment.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/utils/date_to_string.dart';
import 'package:postreal/utils/take_to_profile.dart';

class CommentCard extends StatefulWidget {
  final Comment commentData;
  final String loggedInUserId;
  final String postOwnerId;
  final String postId;
  const CommentCard(
      {super.key,
      required this.commentData,
      required this.loggedInUserId,
      required this.postOwnerId,
      required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    bool isEligibleToDelete = false;
    // to allow commentator or post owner to delete particular comment
    if (widget.loggedInUserId == widget.postOwnerId ||
        widget.commentData.commentatorId == widget.loggedInUserId) {
      isEligibleToDelete = true;
    }
    final String stringDate = dateToString(widget.commentData.dateCommented);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: GestureDetector(
        onTap: () {
          navigateToProfile(widget.commentData.commentatorId);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.commentData.commentatorProfilePicUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.commentData.commentatorUsername,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        stringDate,
                        style: const TextStyle(color: Color(0xFF9E9E9E)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.commentData.text),
                  )
                ],
              ),
            ),
            isEligibleToDelete
                ? IconButton(
                    onPressed: () async {
                      bool? shouldDeletePost = await booleanBottomSheet(
                          context: context,
                          titleText: deleteCommentTitle,
                          boolTrueText: "Delete");
                      try {
                        if (shouldDeletePost!) {
                          final String result = await FirestoreMethods()
                              .deleteComment(
                                  postId: widget.postId,
                                  commentId: widget.commentData.commentId);
                          Fluttertoast.showToast(
                              msg: result, gravity: ToastGravity.CENTER);
                        }
                      } catch (e) {
                        debugPrint("Dismissed delete comment ui");
                      }
                    },
                    icon: const Icon(Icons.delete_outline))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
