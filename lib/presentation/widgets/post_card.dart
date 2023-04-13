import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/shared_layout/profile_screen.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/presentation/widgets/comments_buttom_sheet.dart';
import 'package:postreal/presentation/widgets/like_animation.dart';
import 'package:postreal/utils/date_to_string.dart';
import 'package:provider/provider.dart';
import '../../data/models/user.dart';

class PostCard extends StatefulWidget {
  final Post postData;

  const PostCard({super.key, required this.postData});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final String stringDate = dateToString(widget.postData.datePublished);
    final int likesCount = widget.postData.likes.length;
    final User user = Provider.of<AuthBloc>(context).getCurrentUser;
    bool isEligibleToDeletePost = false;
    // to allow user to delete their own post from feed screen
    if (user.uid == widget.postData.uid) {
      isEligibleToDeletePost = true;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uIdOfProfileOwner: widget.postData.uid)),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        NetworkImage(widget.postData.profilePicUrl),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postData.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    stringDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              bool isLikedOrUnliked = await FirestoreMethods().likeUnlikePost(
                  widget.postData.postId,
                  user.uid,
                  widget.postData.likes,
                  widget.postData.uid,
                  widget.postData.postPicUrl);
              if (!isLikedOrUnliked) {
                Fluttertoast.showToast(
                    msg: "Error: Could not perform like/unlike request");
              }
              if (mounted) {
                setState(() {
                  isLikeAnimating = true;
                });
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  child: PinchZoom(
                    resetDuration: const Duration(milliseconds: 100),
                    child: Image.network(
                      widget.postData.postPicUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      if (mounted) {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.postData.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                    iconSize: 28,
                    onPressed: () async {
                      await FirestoreMethods().likeUnlikePost(
                          widget.postData.postId,
                          user.uid,
                          widget.postData.likes,
                          widget.postData.uid,
                          widget.postData.postPicUrl);
                    },
                    icon: widget.postData.likes.contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          )),
              ),
              IconButton(
                  onPressed: () {
                    commentsButtomSheet(
                        context: context,
                        post: widget.postData,
                        currentUserId: user.uid);
                  },
                  icon: const Icon(Icons.comment_outlined)),
              // IconButton(
              //     iconSize: 28,
              //     onPressed: () {},
              //     icon: const Icon(Icons.send_outlined)),
              isEligibleToDeletePost
                  ? IconButton(
                      onPressed: () async {
                        bool? shouldDeletePost = await booleanBottomSheet(
                            context: context,
                            titleText: deletePostTitle,
                            boolTrueText: "Delete");
                        try {
                          if (shouldDeletePost!) {
                            final String result = await FirestoreMethods()
                                .deletePost(postId: widget.postData.postId);
                            Fluttertoast.showToast(
                                msg: result, gravity: ToastGravity.CENTER);
                          }
                        } catch (err) {
                          debugPrint(
                              "Trigger when user dismisses buttom sheet");
                        }
                      },
                      icon: const Icon(Icons.delete_outline))
                  : const SizedBox(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: likesCount == 0
                ? const Text("")
                : Text(
                    likesCount == 1 ? "1 like" : "$likesCount likes",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              uIdOfProfileOwner: widget.postData.uid)),
                    );
                  },
                  child: Text(
                    widget.postData.username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.postData.caption,
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postData.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text("");
                }

                return InkWell(
                  onTap: () {
                    commentsButtomSheet(
                        context: context,
                        post: widget.postData,
                        currentUserId: user.uid);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2),
                    child: Text(
                      snapshot.data!.docs.length == 1
                          ? "View 1 comment"
                          : "View ${snapshot.data!.docs.length} comments",
                      style: const TextStyle(
                          color: Color(0xFF9E9E9E), fontSize: 16),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
