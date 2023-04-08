import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postreal/data/firestore_methods.dart';

part 'editprofile_event.dart';
part 'editprofile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditClickedEvent>(_editProfile);
  }
  final FirestoreMethods _methods = FirestoreMethods();

  FutureOr<void> _editProfile(
      EditClickedEvent editClickedEvent, Emitter<EditProfileState> emit) async {
    emit.call(EditProfileProcessing());

    bool dataUpdated = true;
    // when both new bio and username are diff, need to update both
    if (editClickedEvent.newBio != editClickedEvent.oldBio &&
        editClickedEvent.newUsername != editClickedEvent.oldUsername) {
      final bool isUpdated = await _methods.updateUsernameAndBio(
          editClickedEvent.newBio,
          editClickedEvent.newUsername,
          editClickedEvent.userId);
      dataUpdated = isUpdated;
    }
    // when bio is new but same old username, need to update just bio
    else if (editClickedEvent.newBio != editClickedEvent.oldBio &&
        editClickedEvent.newUsername == editClickedEvent.oldUsername) {
      final bool isUpdated = await _methods.updateBio(
          editClickedEvent.newBio, editClickedEvent.userId);
      dataUpdated = isUpdated;
    }
    // when username is new but same old bio, need to udapte just username
    else {
      final bool isUpdated = await _methods.updateUsername(
          editClickedEvent.newUsername, editClickedEvent.userId);
      dataUpdated = isUpdated;
    }

    dataUpdated
        ? emit.call(ProfileUpdatedState())
        : emit.call(UpdateErrorState(message: "Could not update profile."));
  }
}
