import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/data/models/user.dart';
import 'package:postreal/utils/image_picker.dart';
part 'addphoto_event.dart';
part 'addphoto_state.dart';

class AddPhotoBloc extends Bloc<AddPhotoEvent, AddPhotoState> {
  AddPhotoBloc() : super(ChoosingPhotoState()) {
    on<AddPhotoInitialEvent>(_initialAddPhotoEvent);
    on<PostClickedEvent>(_addPostClick);
  }

  FutureOr<void> _initialAddPhotoEvent(
      AddPhotoInitialEvent addPhotoInitialEvent,
      Emitter<AddPhotoState> emit) async {
    emit.call(ChoosingPhotoState());

    File? img = await pickImage(defaultTargetPlatform == TargetPlatform.iOS
        ? kDebugMode
            ? ImageSource.gallery
            : ImageSource.camera
        : ImageSource.camera);

    if (img != null) {
      emit.call(PhotoChoosedState(choosedPhoto: img));
    } else {
      emit.call(ImageNotReceivedState());
    }
  }

  FutureOr<void> _addPostClick(
      PostClickedEvent postClickedEvent, Emitter<AddPhotoState> emit) async {
    emit.call(PhotoPostingState(choosedPhoto: postClickedEvent.img));

    String postStatus = await FirestoreMethods().addNewPost(
        img: postClickedEvent.img,
        user: postClickedEvent.user,
        caption: postClickedEvent.caption);

    if (postStatus == "success") {
      emit.call(PhotoPostedState());
    } else {
      emit.call(PostingErrorState(message: postStatus));
    }
  }
}
