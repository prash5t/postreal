import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String bio;
  final String uid;
  final String profilePicUrl;
  final List followers;
  final List following;
  final bool isVerified;
  const User(
      {required this.email,
      required this.username,
      required this.bio,
      required this.uid,
      required this.profilePicUrl,
      required this.followers,
      required this.following,
      this.isVerified = false});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "bio": bio,
        "profilePicUrl": profilePicUrl,
        "followers": followers,
        "following": following,
        "isVerified": isVerified
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = snapshot.data() as Map<String, dynamic>;
    return User(
        email: snap['email'],
        username: snap['username'],
        bio: snap['bio'],
        uid: snap['uid'],
        profilePicUrl: snap['profilePicUrl'],
        followers: snap['followers'],
        following: snap['following'],
        isVerified: snap['isVerified']);
  }
}
