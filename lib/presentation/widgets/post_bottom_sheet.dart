// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/shared_layout/comments_screen.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/utils/date_to_string.dart';

Future<dynamic> postModalBottomSheet(
    {required BuildContext context,
    required Post post,
    required String currentUserId}) {
  bool isEligibleToDeletePost = false;
  // to allow user to delete their own post from feed screen
  if (currentUserId == post.uid) {
    isEligibleToDeletePost = true;
  }
  return showModalBottomSheet(
      isScrollControlled: true,
      elevation: 1,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                  child: Container(color: Colors.grey, width: 150, height: 4)),
            ),
            const SizedBox(height: 10),
            CustomText(text: dateToString(post.datePublished), isBold: true),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(post.profilePicUrl),
              ),
              title: Text(post.username),
              subtitle: Text(
                post.caption,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF9E9E9E)),
              ),
              trailing: isEligibleToDeletePost
                  ? IconButton(
                      onPressed: () async {
                        bool? shouldDeletePost = await booleanBottomSheet(
                            context: context,
                            titleText: deletePostTitle,
                            boolTrueText: "Delete");
                        try {
                          if (shouldDeletePost!) {
                            final String result = await FirestoreMethods()
                                .deletePost(postId: post.postId);
                            Fluttertoast.showToast(
                                msg: result, gravity: ToastGravity.CENTER);
                            Navigator.pop(context);
                          }
                        } catch (err) {
                          debugPrint(
                              "Trigger when user dismisses buttom sheet");
                        }
                      },
                      icon: const Icon(Icons.delete_outline))
                  : null,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: PinchZoom(
                resetDuration: const Duration(milliseconds: 100),
                child: Image.network(
                  post.postPicUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildProfileStatColumn(
                            post.likes.length.toString(), Icons.favorite),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  postData: post,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.comment_sharp),
                              const SizedBox(width: 5),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(post.postId)
                                      .collection('comments')
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.hasError) {
                                      return const CustomText(
                                          text: "---", size: 20, isBold: true);
                                    }
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const CustomText(
                                          text: "0", isBold: true, size: 20);
                                    }
                                    return CustomText(
                                        text: snapshot.data!.docs.length
                                            .toString(),
                                        size: 20,
                                        isBold: true);
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
}

Row buildProfileStatColumn(String value, IconData icon) {
  return Row(
    children: [
      Icon(icon),
      const SizedBox(width: 8),
      CustomText(text: value, size: 20, isBold: true),
    ],
  );
}
