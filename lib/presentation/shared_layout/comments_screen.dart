import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/comment.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/data/models/user.dart';
import 'package:postreal/presentation/widgets/comment_card.dart';
import 'package:postreal/presentation/widgets/user_dp.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final Post postData;
  const CommentsScreen({super.key, required this.postData});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentField = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<AuthBloc>(context).getCurrentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.transparent,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postData.postId)
                .collection('comments')
                .orderBy('dateCommented', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => CommentCard(
                          commentData:
                              Comment.fromSnap(snapshot.data!.docs[index]),
                          loggedInUserId: user.uid,
                          postOwnerId: widget.postData.uid,
                          postId: widget.postData.postId,
                        ));
              } else {
                return const Center(
                    child: Text(
                  "No comments yet.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ));
              }
            }),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8.0),
            child: Row(
              children: [
                UserDP(dpUrl: user.profilePicUrl, isVerified: user.isVerified),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _commentField,
                          decoration: InputDecoration(
                              suffixIcon: TextButton(
                                  onPressed: () async {
                                    if (_commentField.text.trim().isNotEmpty) {
                                      final String result =
                                          await FirestoreMethods()
                                              .commentOnPost(
                                                  postId:
                                                      widget.postData.postId,
                                                  text:
                                                      _commentField.text.trim(),
                                                  commentatorId: user.uid,
                                                  posterId: widget.postData.uid,
                                                  username: user.username,
                                                  profilePicUrl:
                                                      user.profilePicUrl,
                                                  isVerified: user.isVerified,
                                                  postPicUrl: widget
                                                      .postData.postPicUrl);

                                      _commentField.text = "";
                                      if (result == "success") {
                                        Fluttertoast.showToast(
                                            gravity: ToastGravity.CENTER,
                                            msg: "You just commented real!");
                                      } else {
                                        Fluttertoast.showToast(msg: result);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Post",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )),
                              hintText: 'Comment as @${user.username}',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
