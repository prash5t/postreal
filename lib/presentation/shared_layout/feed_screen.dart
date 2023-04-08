import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text("PostReal"),
          actions: [
            IconButton(
                onPressed: () {},
                iconSize: 26,
                icon: const Icon(Icons.message_outlined))
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  key: const PageStorageKey<String>('feedsPage'),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                      postData: Post.fromSnap(snapshot.data!.docs[index])));
            },
          ),
        ));
  }
}
