import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final List likes;
  final String username;
  final DateTime datePublished;
  final String profilePicUrl;
  final bool isVerified;
  final String postPicUrl;
  final String postId;

  const Post(
      {required this.caption,
      required this.uid,
      required this.likes,
      required this.username,
      required this.datePublished,
      required this.profilePicUrl,
      required this.isVerified,
      required this.postPicUrl,
      required this.postId});

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "uid": uid,
        "likes": likes,
        "username": username,
        "datePublished": datePublished,
        "profilePicUrl": profilePicUrl,
        "isVerified": isVerified,
        "postPicUrl": postPicUrl,
        "postId": postId
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        caption: snap['caption'],
        uid: snap['uid'],
        likes: snap['likes'],
        username: snap['username'],
        datePublished: snap['datePublished'].toDate(),
        profilePicUrl: snap['profilePicUrl'],
        isVerified: snap['isVerified'] ?? false,
        postPicUrl: snap['postPicUrl'],
        postId: snap['postId']);
  }
}
