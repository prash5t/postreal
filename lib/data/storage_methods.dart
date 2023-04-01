import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// function to upload image and return image url
  Future<String> uploadImageToStorage({
    required String childName,
    required File img,
    bool isPost = false,
  }) async {
    Reference ref =
        _firebaseStorage.ref(childName).child(_firebaseAuth.currentUser!.uid);

    if (isPost) {
      String postPicId = const Uuid().v1();
      ref = ref.child(postPicId);
    }

    UploadTask uploadTask = ref.putFile(img);
    TaskSnapshot snap = await uploadTask;
    String imgUrl = await snap.ref.getDownloadURL();
    return imgUrl;
  }
}
