import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/editprofile_bloc/editprofile_bloc.dart';
import 'package:postreal/presentation/shared_layout/home_screen.dart';
import 'package:postreal/utils/validator.dart';

class EditProfileScreen extends StatefulWidget {
  final Map dataofProfileOwner;

  const EditProfileScreen({super.key, required this.dataofProfileOwner});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _updateProfileKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = widget.dataofProfileOwner['username'];
    _bioController.text = widget.dataofProfileOwner['bio'];
    return BlocProvider<EditProfileBloc>(
      create: (context) => EditProfileBloc(),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, editProfileState) {
        if (editProfileState is ProfileUpdatedState) {
          Fluttertoast.showToast(msg: "Profile updated");
          return const HomeScreen();
        } else if (editProfileState is UpdateErrorState) {
          Fluttertoast.showToast(msg: editProfileState.message!);
        }
        return Scaffold(
            body: SafeArea(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
              key: _updateProfileKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return TextFieldValidator.validateUsername(value);
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                  TextFormField(
                    controller: _bioController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return TextFieldValidator.bioValidator(value);
                    },
                    maxLines: 3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: "Bio"),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_updateProfileKey.currentState!.validate()) {
                            final String newUsername =
                                _usernameController.text.trim();
                            final String newBio = _bioController.text.trim();
                            // when user makes no changes in fields
                            if (newUsername ==
                                    widget.dataofProfileOwner['username'] &&
                                newBio == widget.dataofProfileOwner['bio']) {
                              Navigator.pop(context);
                            }
                            // when there is new info, we need to update info
                            else {
                              context.read<EditProfileBloc>().add(
                                  (EditClickedEvent(
                                      newUsername: newUsername,
                                      newBio: newBio,
                                      oldUsername:
                                          widget.dataofProfileOwner['username'],
                                      oldBio: widget.dataofProfileOwner['bio'],
                                      userId:
                                          widget.dataofProfileOwner['uid'])));
                            }
                          }
                        },
                        child: (editProfileState is EditProfileProcessing)
                            ? const LinearProgressIndicator()
                            : const Text("Update")),
                  ),
                  TextButton(
                      onPressed: (editProfileState is EditProfileProcessing)
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text("Dissmiss"))
                ],
              )),
        )));
      }),
    );
  }
}
