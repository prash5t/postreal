// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/business_logic/editprofile_bloc/editprofile_bloc.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/constants/routes.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/data/models/user.dart';
import 'package:postreal/presentation/shared_layout/edit_profile.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/presentation/widgets/post_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uIdOfProfileOwner;
  const ProfileScreen({super.key, required this.uIdOfProfileOwner});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  var dataOfProfileOwner = {};
  late QuerySnapshot postsOfThisUser;
  int totalPostsOfThisUser = 0;
  bool dataOfProfileFetched = false;
  bool followUnfollowTaskGoingOn =
      false; // to show loading indicator while follow/unfollow click
  @override
  void initState() {
    super.initState();
    fetchDataOfProfileOwner();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchDataOfProfileOwner() async {
    try {
      // getting data of profile
      var profileData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uIdOfProfileOwner)
          .get();
      dataOfProfileOwner = profileData.data()!;

      // getting posts of this user
      postsOfThisUser = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uIdOfProfileOwner)
          .get();

      totalPostsOfThisUser = postsOfThisUser.docs.length;

      setState(() {
        dataOfProfileFetched = true;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!dataOfProfileFetched) {
      return const Material(child: Center(child: CircularProgressIndicator()));
    }
    // before building Profile UI, we need to know whether the user is visiting their own profile
    // or visiting profile of someone they already followed
    // or visiting profile of someone they have not followed
    // to allow user either to edit profile or follow/unfollow user
    // and to show Sign out option if they are visiting their own profile
    final User loggedInUser = Provider.of<UserProvider>(context).getUser;
    bool isProfileOwner = false;
    bool alreadyFollowed = false;
    if (loggedInUser.uid == widget.uIdOfProfileOwner) {
      isProfileOwner = true;
    }
    if (loggedInUser.following.contains(widget.uIdOfProfileOwner)) {
      alreadyFollowed = true;
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Colors.transparent,
            title: Text(dataOfProfileOwner['username']),
            centerTitle: false,
            actions: [
              isProfileOwner
                  ? IconButton(
                      onPressed: () async {
                        bool? shouldLogout = await booleanBottomSheet(
                            context: context,
                            titleText: logoutTitle,
                            boolTrueText: "Sign out");
                        try {
                          if (shouldLogout!) {
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogoutClickedEvent());
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.loginscreen);
                            Fluttertoast.showToast(
                                msg: "Logged out...",
                                gravity: ToastGravity.CENTER);
                          }
                        } catch (e) {
                          debugPrint("Dismissed from signuout ui");
                        }
                      },
                      icon: const Icon(Icons.logout))
                  : const SizedBox()
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                dataOfProfileOwner['profilePicUrl']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfileStatColumn(
                                    totalPostsOfThisUser, "Posts"),
                                buildProfileStatColumn(
                                    dataOfProfileOwner['followers'].length,
                                    'Followers'),
                                buildProfileStatColumn(
                                    dataOfProfileOwner['following'].length,
                                    "Following")
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(dataOfProfileOwner['bio']),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (isProfileOwner) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                            username:
                                                dataOfProfileOwner['username'],
                                            bio: dataOfProfileOwner['bio'],
                                            userId: loggedInUser.uid,
                                          )),
                                );
                              } else {
                                setState(() {
                                  followUnfollowTaskGoingOn = true;
                                });
                                alreadyFollowed
                                    ? _firestoreMethods.unFollowUser(
                                        stalkedPersonId:
                                            widget.uIdOfProfileOwner,
                                        stalkerId: loggedInUser.uid)
                                    : _firestoreMethods.followUser(
                                        stalkedPersonId:
                                            widget.uIdOfProfileOwner,
                                        stalkerId: loggedInUser.uid);

                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .refreshUser();
                                setState(() {
                                  fetchDataOfProfileOwner();
                                  followUnfollowTaskGoingOn = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: isProfileOwner
                                    ? Colors.grey
                                    : alreadyFollowed
                                        ? Colors.grey
                                        : Colors.blueAccent),
                            child: followUnfollowTaskGoingOn
                                ? const LinearProgressIndicator()
                                : Text(
                                    isProfileOwner
                                        ? "Edit Profile"
                                        : alreadyFollowed
                                            ? "Unfollow @${dataOfProfileOwner['username']}"
                                            : "Follow @${dataOfProfileOwner['username']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.8,
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uIdOfProfileOwner)
                        .get(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 1,
                                  childAspectRatio: 1),
                          itemBuilder: ((context, index) {
                            Post post =
                                Post.fromSnap(snapshot.data!.docs[index]);
                            return GestureDetector(
                              onTap: () {
                                postModalBottomSheet(
                                    context: context,
                                    post: post,
                                    currentUserId: loggedInUser.uid);
                              },
                              child: Image(
                                image: NetworkImage(
                                  post.postPicUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          }));
                    }))
              ],
            ),
          ),
        ),
        followUnfollowTaskGoingOn
            ? const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black45),
              )
            : const SizedBox()
      ],
    );
  }

  Column buildProfileStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$num",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
