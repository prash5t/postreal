import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/data/models/comment.dart';
import 'package:postreal/data/models/post.dart';
import 'package:postreal/data/models/user.dart' as model;
import 'package:postreal/data/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _authMethods = AuthMethods();

  // function to add new post/photo
  Future<String> addNewPost({
    required File img,
    String? caption,
    required model.User user,
  }) async {
    String result;
    try {
      // to upload new picture
      String pictureUrl = await StorageMethods()
          .uploadImageToStorage(childName: "postPics", img: img, isPost: true);

      // after uploading picture,
      // need to create a post that contains pic and caption
      Post post = Post(
        caption: "${caption?.trim()}",
        uid: user.uid,
        likes: [],
        username: user.username.trim(),
        datePublished: DateTime.now(),
        profilePicUrl: user.profilePicUrl,
        postPicUrl: pictureUrl,
        postId: const Uuid().v1(),
      );
      await _firestore.collection('posts').doc(post.postId).set(post.toJson());

      result = "success";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }

  // function to update username
  // not using try/catch here because it will be taken care in the editprofile_bloc
  Future<bool> updateUsername(
      String newUsername, String oldUsername, String userId) async {
    if (newUsername == oldUsername) {
      return true;
    }
    if (await _authMethods.userExits(newUsername)) {
      return false;
    }
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'username': newUsername});
    return true;
  }

  // function to update username
  Future<bool> updateBio(String newBio, String oldBio, String userId) async {
    if (newBio == oldBio) {
      return true;
    }
    await _firestore.collection('users').doc(userId).update({'bio': newBio});
    return true;
  }

  // function to update both username and bio
  // Future<bool> updateUsernameAndBio(
  //     String newBio, String newUsername, String userId) async {
  //   try {
  //     if (await _authMethods.userExits(newUsername)) {
  //       return false;
  //     }
  //     await _firestore
  //         .collection('users')
  //         .doc(userId)
  //         .update({'username': newUsername, 'bio': newBio});
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // function to like or unlike a post
  Future<bool> likeUnlikePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      return false;
    }
    return true;
  }

  // function to follow user
  Future<void> followUser({
    required String stalkedPersonId,
    required String stalkerId,
  }) async {
    DocumentReference stalkedPersonRef =
        _firestore.collection('users').doc(stalkedPersonId);
    DocumentReference stalkerRef =
        _firestore.collection('users').doc(stalkerId);
    WriteBatch batch = _firestore.batch();
    batch.update(stalkedPersonRef, {
      'followers': FieldValue.arrayUnion([stalkerId])
    });
    batch.update(stalkerRef, {
      'following': FieldValue.arrayUnion([stalkedPersonId])
    });
    await batch.commit();
  }

  // function to unfollow user
  Future<void> unFollowUser({
    required String stalkedPersonId,
    required String stalkerId,
  }) async {
    DocumentReference stalkedPersonRef =
        _firestore.collection('users').doc(stalkedPersonId);
    DocumentReference stalkerRef =
        _firestore.collection('users').doc(stalkerId);
    WriteBatch batch = _firestore.batch();
    batch.update(stalkedPersonRef, {
      'followers': FieldValue.arrayRemove([stalkerId])
    });
    batch.update(stalkerRef, {
      'following': FieldValue.arrayRemove([stalkedPersonId])
    });
    await batch.commit();
  }

  // function to comment on post
  Future<String> commentOnPost(
      {required String postId,
      required String text,
      required String uid,
      required String username,
      required String profilePicUrl}) async {
    String result;
    try {
      Comment comment = Comment(
          text: text.trim(),
          commentId: const Uuid().v1(),
          commentatorProfilePicUrl: profilePicUrl,
          commentatorUsername: username,
          commentatorId: uid,
          dateCommented: DateTime.now());
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.commentId)
          .set(comment.toJson());
      result = "success";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }

  //function to delete a comment on a post
  Future<String> deleteComment(
      {required String postId, required String commentId}) async {
    String result;
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      result = "Comment successfully deleted.";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }

  // function to delete a post
  Future<String> deletePost({required String postId}) async {
    String result;
    try {
      await _firestore.collection('posts').doc(postId).delete();
      result = "Post successfully deleted.";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }
}
