import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/editprofile_bloc/editprofile_bloc.dart';
import 'package:postreal/presentation/widgets/super_user_widget.dart';
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
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, editProfileState) {
        if (editProfileState is ProfileUpdatedState) {
          Fluttertoast.showToast(msg: "Profile updated");
          Navigator.of(context).pop();
        } else if (editProfileState is UpdateErrorState) {
          Fluttertoast.showToast(msg: editProfileState.message!);
        }
      }, builder: (context, editProfileState) {
        return Scaffold(
            bottomNavigationBar: SafeArea(
              child: SuperUserWidget(
                  dpUrl: widget.dataofProfileOwner['profilePicUrl'],
                  username: widget.dataofProfileOwner['username'],
                  isVerified: widget.dataofProfileOwner['isVerified']),
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                  key: _updateProfileKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                          readOnly: true,
                          initialValue: widget.dataofProfileOwner['email'],
                          decoration: InputDecoration(
                              labelText: "Email",
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.lock_person_outlined)))),
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
                        maxLines: 2,
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
                                final String newBio =
                                    _bioController.text.trim();
                                context.read<EditProfileBloc>().add(
                                    (EditClickedEvent(
                                        newUsername: newUsername,
                                        newBio: newBio,
                                        oldUsername: widget
                                            .dataofProfileOwner['username'],
                                        oldBio:
                                            widget.dataofProfileOwner['bio'],
                                        userId:
                                            widget.dataofProfileOwner['uid'])));
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
