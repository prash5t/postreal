import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postreal/business_logic/switch_theme_cubit/switch_theme_cubit.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/presentation/themes/dark_theme.dart';
import 'package:postreal/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  final ScrollController feedScrollController;
  const FeedScreen({super.key, required this.feedScrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text("PostReal"),
          actions: [
            BlocBuilder<SwitchThemeCubit, ThemeData>(
                builder: (context, currentTheme) {
              return CupertinoSwitch(
                  thumbColor: Theme.of(context).colorScheme.primary,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: currentTheme == darkTheme,
                  onChanged: (bool val) {
                    BlocProvider.of<SwitchThemeCubit>(context).switchTheme();
                  });
            }),
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
                  controller: feedScrollController,
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
