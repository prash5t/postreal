import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  try {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
  } catch (error) {
    Fluttertoast.showToast(msg: "Invalid image format");
  }
}
