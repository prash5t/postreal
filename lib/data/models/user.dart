import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String username;
  final String? password;
  final String bio;
  final String? uid;
  final String? profilePicUrl;
  final File? profilePicFile;
  final List? followers;
  final List? following;
  final bool isVerified;
  const User(
      {required this.email,
      required this.username,
      this.password,
      required this.bio,
      this.uid,
      this.profilePicUrl,
      this.profilePicFile,
      this.followers,
      this.following,
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

  static fromJson(Map<String, dynamic> userMap) {
    try {
      return User(
          uid: userMap['id'],
          username: userMap['username'],
          email: userMap['email'],
          bio: userMap['bio'],
          profilePicUrl: userMap['profilePicUrl'],
          isVerified: userMap['is_verified']);
    } catch (err) {
      debugPrint("Deserializing User Catch: $err");
      return null;
    }
  }
}
