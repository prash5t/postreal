import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/widgets/post_bottom_sheet.dart';
import 'package:postreal/presentation/widgets/user_dp.dart';
import 'package:postreal/presentation/widgets/username_widget.dart';
import 'package:postreal/providers/user_provider.dart';
import 'package:postreal/utils/take_to_profile.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';

class SearchScreen extends StatefulWidget {
  final ScrollController searchFeedScrollController;
  const SearchScreen({super.key, required this.searchFeedScrollController});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchField = TextEditingController();
  bool shouldSuggestUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.1,
          title: TextFormField(
            controller: _searchField,
            onChanged: (String searchText) {
              setState(() {
                shouldSuggestUsers = true;
              });
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search by username",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: !shouldSuggestUsers
                    ? const SizedBox()
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _searchField.text = "";
                            shouldSuggestUsers = false;
                          });
                        },
                        child: const Text("Cancel"),
                      )),
          ),
        ),
        body: shouldSuggestUsers
            ? SafeArea(
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isGreaterThanOrEqualTo: _searchField.text)
                        .get(),
                    builder: (context, usersSnapshot) {
                      if (!usersSnapshot.hasData ||
                          usersSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Text(
                              "Suggested users: ${usersSnapshot.data!.docs.isEmpty ? "0" : "${usersSnapshot.data!.docs.length}"}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: usersSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  User thisUser = User.fromSnap(
                                      usersSnapshot.data!.docs[index]);
                                  return InkWell(
                                    onTap: () {
                                      navigateToProfile(thisUser.uid);
                                    },
                                    child: ListTile(
                                      leading: UserDP(
                                          dpUrl: thisUser.profilePicUrl,
                                          isVerified: thisUser.isVerified),
                                      title: UsernameWidget(
                                          isVerified: thisUser.isVerified,
                                          username: thisUser.username),
                                      subtitle: Text(thisUser.bio),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }),
              )
            : SafeArea(
                child: FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection('posts').get(),
                    builder: (context, postSnapshot) {
                      if (!postSnapshot.hasData ||
                          postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return StaggeredGridView.countBuilder(
                        controller: widget.searchFeedScrollController,
                        key: const PageStorageKey<String>('searchFeedPage'),
                        crossAxisCount: 3,
                        itemCount: postSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Post post =
                              Post.fromSnap(postSnapshot.data!.docs[index]);
                          return Container(
                            color: Colors.grey,
                            child: InkWell(
                              onTap: () {
                                postModalBottomSheet(
                                    context: context,
                                    post: post,
                                    currentUserId: loggedInUser.uid);
                              },
                              child: Image.network(
                                post.postPicUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) => StaggeredTile.count(
                            (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      );
                    }),
              ));
  }
}
