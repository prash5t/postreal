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
      EditClickedEvent event, Emitter<EditProfileState> emit) async {
    emit.call(EditProfileProcessing());
    try {
      // update each field serially
      bool usernameUpdated = await _methods.updateUsername(
          event.newUsername, event.oldUsername, event.userId);
      if (!usernameUpdated) {
        emit.call(UpdateErrorState(message: "This username is already taken."));
      } else {
        await _methods.updateBio(event.newBio, event.oldBio, event.userId);
        emit.call(ProfileUpdatedState());
      }
    } catch (e) {
      emit.call(UpdateErrorState(message: e.toString()));
    }
  }
}
