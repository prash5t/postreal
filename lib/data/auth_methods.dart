import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postreal/data/models/user.dart' as model;
import 'package:postreal/data/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User? user = auth.currentUser;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(user?.uid).get();
    return model.User.fromSnap(snapshot);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<String> loginUser(String email, String password) async {
    String result;
    try {
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      result = "success";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }

  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required File selfieFile}) async {
    String result;
    try {
      // first we need to check if user with this username already exists or not
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return "This username is already used.";
      }

      // second need to register user to firebase authentication if username is unique
      UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      // after registering user auth, need to upload user's profile picture
      String profilePicUrl = await StorageMethods()
          .uploadImageToStorage(childName: "profilePics", img: selfieFile);

      // after uploading profile picture of user,
      // need to store user's information to firebase database
      model.User user = model.User(
          email: email.trim(),
          username: username.trim(),
          bio: bio.trim(),
          uid: cred.user!.uid,
          profilePicUrl: profilePicUrl,
          followers: [],
          following: []);
      await firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());

      result = "success";
    } catch (err) {
      result = err.toString().replaceAll(RegExp(r'\[[^\]]+\]'), '');
    }
    return result;
  }
}
