import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/addphoto_bloc/addphoto_bloc.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/data/models/user.dart';
import 'package:postreal/main.dart';
import 'package:postreal/utils/validator.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionField = TextEditingController();
  final _postKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<AuthBloc>(context).getCurrentUser;
    return BlocProvider<AddPhotoBloc>(
      create: (context) => AddPhotoBloc()..add(AddPhotoInitialEvent()),
      child:
          BlocConsumer<AddPhotoBloc, AddPhotoState>(listener: (context, state) {
        if (state is ImageNotReceivedState) {
          Navigator.of(navKey.currentContext!).pop();
        } else if (state is PostingErrorState) {
          Fluttertoast.showToast(
              msg: "Something went wrong and could not post your picture");
          Navigator.of(navKey.currentContext!).pop();
        } else if (state is PhotoPostedState) {
          Fluttertoast.showToast(msg: "You just posted real");
          Navigator.of(navKey.currentContext!).pop();
        }
      }, builder: (context, state) {
        // below is the UI when photo is choosed
        if (state is PhotoChoosedState) {
          return Form(
            key: _postKey,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.1,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (_postKey.currentState!.validate()) {
                        context.read<AddPhotoBloc>().add(PostClickedEvent(
                            img: state.choosedPhoto,
                            user: user,
                            caption: _captionField.text));
                      }
                    },
                    child: (state is PhotoPostingState)
                        ? const SizedBox()
                        : const Text(
                            "Post",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () =>
                    context.read<AddPhotoBloc>().add(AddPhotoInitialEvent()),
                label: const Text("Retake"),
                icon: const Icon(Icons.add_a_photo),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                            maxLines: 3,
                            controller: _captionField,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                TextFieldValidator.captionValidator(value),
                            decoration: const InputDecoration(
                                hintText: "Write a caption...",
                                border: OutlineInputBorder())),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: double.infinity,
                            height: 500,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(state.choosedPhoto))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is PhotoPostingState) {
          return Material(
            child: Center(
                child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.file(
                    state.choosedPhoto,
                    fit: BoxFit.cover,
                  ),
                ),
                const CircularProgressIndicator(),
                const Text("Uploading"),
              ],
            )),
          );
        }

        // choosing photo state below
        return Material(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text("Please wait... Camera service in progress..."),
            ],
          )),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _captionField.dispose();
  }
}
